defmodule WhyZeeWeb.PostLive.Index do
  use WhyZeeWeb, :live_view

  alias WhyZee.Content
  alias WhyZee.Content.Post

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

    if socket.assigns.current_user do
      {:ok, stream(socket, :posts, Content.list_user_posts(socket.assigns.current_user.id))}
    else
      {:ok, stream(socket, :posts, Content.list_posts())}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Content.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({WhyZeeWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Content.get_post!(id)
    {:ok, _} = Content.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
