defmodule Pleroma.Web.MastodonAPI.StatusView do
  use Pleroma.Web, :view
  alias Pleroma.Web.MastodonAPI.{AccountView, StatusView}
  alias Pleroma.{User, Activity}
  alias Pleroma.Web.CommonAPI.Utils

  def render("index.json", opts) do
    render_many(opts.activities, StatusView, "status.json", opts)
  end

  def render("status.json", %{activity: %{data: %{"object" => object}} = activity} = opts) do
    user = User.get_cached_by_ap_id(activity.data["actor"])

    like_count = object["like_count"] || 0
    announcement_count = object["announcement_count"] || 0

    tags = object["tag"] || []
    sensitive = Enum.member?(tags, "nsfw")

    mentions = activity.data["to"]
    |> Enum.map(fn (ap_id) -> User.get_cached_by_ap_id(ap_id) end)
    |> Enum.filter(&(&1))
    |> Enum.map(fn (user) -> AccountView.render("mention.json", %{user: user}) end)

    repeated = opts[:for] && opts[:for].ap_id in (object["announcements"] || [])
    favorited = opts[:for] && opts[:for].ap_id in (object["likes"] || [])

    attachments = render_many(object["attachment"] || [], StatusView, "attachment.json", as: :attachment)

    created_at = Utils.to_masto_date(object["published"])

    # TODO: Add cached version.
    reply_to = Activity.get_create_activity_by_object_ap_id(object["inReplyTo"])
    reply_to_user = reply_to && User.get_cached_by_ap_id(reply_to.data["actor"])

    %{
      id: activity.id,
      uri: object["id"],
      url: object["external_url"],
      account: AccountView.render("account.json", %{user: user}),
      in_reply_to_id: reply_to && reply_to.id,
      in_reply_to_account_id: reply_to_user && reply_to_user.id,
      reblog: nil,
      content: HtmlSanitizeEx.basic_html(object["content"]),
      created_at: created_at,
      reblogs_count: announcement_count,
      favourites_count: like_count,
      reblogged: !!repeated,
      favourited: !!favorited,
      muted: false,
      sensitive: sensitive,
      spoiler_text: "",
      visibility: "public",
      media_attachments: attachments,
      mentions: mentions,
      tags: [], # fix,
      application: %{
        name: "Web",
        website: nil
      },
      language: nil
    }
  end

  def render("attachment.json", %{attachment: attachment}) do
    [%{"mediaType" => media_type, "href" => href} | _] = attachment["url"]

    type = cond do
      String.contains?(media_type, "image") -> "image"
      String.contains?(media_type, "video") -> "video"
      true -> "unknown"
    end

    << hash_id::signed-32, _rest::binary >> = :crypto.hash(:md5, href)

    %{
      id: attachment["id"] || hash_id,
      url: href,
      remote_url: href,
      preview_url: href,
      text_url: href,
      type: type
    }
  end
end
