# Pleroma: A lightweight social networking server
# Copyright © 2017-2020 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.AdminAPI.InviteTokenController do
  use Pleroma.Web, :controller

  import Pleroma.Web.ControllerHelper, only: [json_response: 3]

  alias Pleroma.Config
  alias Pleroma.Plugs.OAuthScopesPlug
  alias Pleroma.UserInviteToken
  alias Pleroma.Web.AdminAPI.AccountView

  require Logger

  plug(OAuthScopesPlug, %{scopes: ["read:invites"], admin: true} when action == :index)

  plug(
    OAuthScopesPlug,
    %{scopes: ["write:invites"], admin: true} when action in [:create, :revoke, :email]
  )

  action_fallback(Pleroma.Web.AdminAPI.FallbackController)

  @doc "Get list of created invites"
  def index(conn, _params) do
    invites = UserInviteToken.list_invites()

    conn
    |> put_view(AccountView)
    |> render("invites.json", %{invites: invites})
  end

  @doc "Create an account registration invite token"
  def create(conn, params) do
    opts = %{}

    opts =
      if params["max_use"],
        do: Map.put(opts, :max_use, params["max_use"]),
        else: opts

    opts =
      if params["expires_at"],
        do: Map.put(opts, :expires_at, params["expires_at"]),
        else: opts

    {:ok, invite} = UserInviteToken.create_invite(opts)

    json(conn, AccountView.render("invite.json", %{invite: invite}))
  end

  @doc "Revokes invite by token"
  def revoke(conn, %{"token" => token}) do
    with {:ok, invite} <- UserInviteToken.find_by_token(token),
         {:ok, updated_invite} = UserInviteToken.update_invite(invite, %{used: true}) do
      conn
      |> put_view(AccountView)
      |> render("invite.json", %{invite: updated_invite})
    else
      nil -> {:error, :not_found}
    end
  end

  @doc "Sends registration invite via email"
  def email(%{assigns: %{user: user}} = conn, %{"email" => email} = params) do
    with {_, false} <- {:registrations_open, Config.get([:instance, :registrations_open])},
         {_, true} <- {:invites_enabled, Config.get([:instance, :invites_enabled])},
         {:ok, invite_token} <- UserInviteToken.create_invite(),
         email <-
           Pleroma.Emails.UserEmail.user_invitation_email(
             user,
             invite_token,
             email,
             params["name"]
           ),
         {:ok, _} <- Pleroma.Emails.Mailer.deliver(email) do
      json_response(conn, :no_content, "")
    else
      {:registrations_open, _} ->
        {:error, "To send invites you need to set the `registrations_open` option to false."}

      {:invites_enabled, _} ->
        {:error, "To send invites you need to set the `invites_enabled` option to true."}
    end
  end
end
