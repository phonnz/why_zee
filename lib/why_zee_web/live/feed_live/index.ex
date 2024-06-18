defmodule WhyZeeWeb.FeedLive.Index do
  use WhyZeeWeb, :live_view

  alias WhyZee.Content

  alias WhyZee.Repo
  import Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    token = session["user_token"]

    socket =
      if token do
        user =
          from(u in WhyZee.Accounts.User)
          |> join(:left, [u], t in WhyZee.Accounts.UserToken, on: u.id == t.user_id)
          |> select([u, t], u)
          |> where([u, t], t.token == ^token)
          |> first()
          |> Repo.one()

        assign(socket, :current_user, user)
      else
        socket
      end

    {:ok, stream(socket, :posts, Content.list_posts())}
  end

  @impl true
  def handle_event("like", %{"id" => post_id}, socket) do
    Content.increase_post_likes(post_id, socket.assigns.current_user.id)

    {:noreply, stream(socket, :posts, Content.list_posts())}
  end
end
