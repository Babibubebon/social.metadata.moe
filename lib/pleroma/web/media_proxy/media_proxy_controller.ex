# Pleroma: A lightweight social networking server
# Copyright © 2017-2020 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.MediaProxy.MediaProxyController do
  use Pleroma.Web, :controller

  alias Pleroma.Config
  alias Pleroma.Helpers.MediaHelper
  alias Pleroma.ReverseProxy
  alias Pleroma.Web.MediaProxy

  def remote(conn, %{"sig" => sig64, "url" => url64}) do
    with {_, true} <- {:enabled, MediaProxy.enabled?()},
         {:ok, url} <- MediaProxy.decode_url(sig64, url64),
         {_, false} <- {:in_banned_urls, MediaProxy.in_banned_urls(url)},
         :ok <- MediaProxy.verify_request_path_and_url(conn, url) do
      ReverseProxy.call(conn, url, media_proxy_opts())
    else
      {:enabled, false} ->
        send_resp(conn, 404, Plug.Conn.Status.reason_phrase(404))

      {:in_banned_urls, true} ->
        send_resp(conn, 404, Plug.Conn.Status.reason_phrase(404))

      {:error, :invalid_signature} ->
        send_resp(conn, 403, Plug.Conn.Status.reason_phrase(403))

      {:wrong_filename, filename} ->
        redirect(conn, external: MediaProxy.build_url(sig64, url64, filename))
    end
  end

  def preview(conn, %{"sig" => sig64, "url" => url64}) do
    with {_, true} <- {:enabled, MediaProxy.preview_enabled?()},
         {:ok, url} <- MediaProxy.decode_url(sig64, url64) do
      handle_preview(conn, url)
    else
      {:enabled, false} ->
        send_resp(conn, 404, Plug.Conn.Status.reason_phrase(404))

      {:error, :invalid_signature} ->
        send_resp(conn, 403, Plug.Conn.Status.reason_phrase(403))

      {:wrong_filename, filename} ->
        redirect(conn, external: MediaProxy.build_preview_url(sig64, url64, filename))
    end
  end

  defp handle_preview(conn, url) do
    with {:ok, %{status: status} = head_response} when status in 200..299 <-
           Pleroma.HTTP.request("head", MediaProxy.url(url), [], [], [adapter: [pool: :preview]]) do
      content_type = Tesla.get_header(head_response, "content-type")
      handle_preview(content_type, conn, url)
    else
      {_, %{status: status}} ->
        send_resp(conn, :failed_dependency, "Can't fetch HTTP headers (HTTP #{status}).")

      {:error, :recv_response_timeout} ->
        send_resp(conn, :failed_dependency, "HEAD request timeout.")

      _ ->
        send_resp(conn, :failed_dependency, "Can't fetch HTTP headers.")
    end
  end

  # TODO: find a workaround so avatar_static and header_static can work.
  # Those only permit GIFs for animation, so we have to permit a way to
  # allow those to get real static variants.
  defp handle_preview("image/gif" = _content_type, conn, url) do
    mediaproxy_url = url |> MediaProxy.url()

    redirect(conn, external: mediaproxy_url)
  end

  defp handle_preview("image/png" <> _ = _content_type, conn, url) do
    handle_png_preview(conn, url)
  end

  defp handle_preview("image/" <> _ = _content_type, conn, url) do
    handle_jpeg_preview(conn, url)
  end

  defp handle_preview("video/" <> _ = _content_type, conn, url) do
    handle_video_preview(conn, url)
  end

  defp handle_preview(content_type, conn, _url) do
    send_resp(conn, :unprocessable_entity, "Unsupported content type: #{content_type}.")
  end

  defp handle_png_preview(%{params: params} = conn, url) do
    quality = Config.get!([:media_preview_proxy, :image_quality])

    with {thumbnail_max_width, thumbnail_max_height} <- thumbnail_max_dimensions(params),
         {:ok, thumbnail_binary} <-
           MediaHelper.image_resize(
             url,
             %{
               max_width: thumbnail_max_width,
               max_height: thumbnail_max_height,
               quality: quality,
               format: "png"
             }
           ) do
      conn
      |> put_preview_response_headers("image/png", "preview.png")
      |> send_resp(200, thumbnail_binary)
    else
      _ ->
        send_resp(conn, :failed_dependency, "Can't handle preview.")
    end
  end

  defp handle_jpeg_preview(%{params: params} = conn, url) do
    quality = Config.get!([:media_preview_proxy, :image_quality])

    with {thumbnail_max_width, thumbnail_max_height} <- thumbnail_max_dimensions(params),
         {:ok, thumbnail_binary} <-
           MediaHelper.image_resize(
             url,
             %{max_width: thumbnail_max_width, max_height: thumbnail_max_height, quality: quality}
           ) do
      conn
      |> put_preview_response_headers()
      |> send_resp(200, thumbnail_binary)
    else
      _ ->
        send_resp(conn, :failed_dependency, "Can't handle preview.")
    end
  end

  defp handle_video_preview(conn, url) do
    with {:ok, thumbnail_binary} <-
           MediaHelper.video_framegrab(url) do
      conn
      |> put_preview_response_headers()
      |> send_resp(200, thumbnail_binary)
    else
      _ ->
        send_resp(conn, :failed_dependency, "Can't handle preview.")
    end
  end

  defp put_preview_response_headers(conn, content_type \\ "image/jpeg", filename \\ "preview.jpg") do
    conn
    |> put_resp_header("content-type", content_type)
    |> put_resp_header("content-disposition", "inline; filename=\"#{filename}\"")
    |> put_resp_header("cache-control", "max-age=0, private, must-revalidate")
  end

  defp thumbnail_max_dimensions(params) do
    config = Config.get([:media_preview_proxy], [])

    thumbnail_max_width =
      if w = params["thumbnail_max_width"] do
        String.to_integer(w)
      else
        Keyword.fetch!(config, :thumbnail_max_width)
      end

    thumbnail_max_height =
      if h = params["thumbnail_max_height"] do
        String.to_integer(h)
      else
        Keyword.fetch!(config, :thumbnail_max_height)
      end

    {thumbnail_max_width, thumbnail_max_height}
  end

  defp media_proxy_opts do
    Config.get([:media_proxy, :proxy_opts], [])
  end
end
