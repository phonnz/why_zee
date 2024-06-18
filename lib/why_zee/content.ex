defmodule WhyZee.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias WhyZee.Repo

  alias WhyZee.Content.{Post, UsersPosts}

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    from(p in Post)
    |> join(:left, [p], u in assoc(p, :user), as: :user)
    |> preload([p, u], user: u)
    |> order_by(asc: :inserted_at)
    |> Repo.all()
  end

  def list_user_posts(user_id) do
    from(p in Post)
    |> where([p], p.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(current_user, attrs \\ %{}) do
    current_user
    |> Ecto.build_assoc(:posts)
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def submit_likes(like_map) when like_map == %{}, do: {:ok, 0}

  def submit_likes(like_map) do
    like_map
    |> Enum.map(fn {post_id, likes} ->
      Post
      |> where([p], p.id == ^post_id)
      |> Repo.update_all(inc: [likes: 1])
    end)
    |> dbg

    {:ok, :updated}
  end

  def increase_post_likes(post_id, user_id) do
    user_like =
      from(up in WhyZee.Content.UsersPosts)
      |> where([up], up.user_id == ^user_id and up.post_id == ^post_id)
      |> Repo.one()

    if is_nil(user_like) do
      Repo.transaction(fn ->
        Post
        |> where([p], p.id == ^post_id)
        |> Repo.update_all(inc: [likes: 1])

        %WhyZee.Content.UsersPosts{}
        |> UsersPosts.changeset(%{user_id: user_id, post_id: post_id})
        |> Repo.insert()
      end)
    else
      Repo.transaction(fn ->
        Post
        |> where([p], p.id == ^post_id)
        |> Repo.update_all(inc: [likes: -1])

        Repo.delete(user_like)
      end)
    end
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias WhyZee.Content.PostsUsersViews

  def update_views(user_id, post_id) do
    increase_query = from(p in Post, where: p.id == ^post_id, update: [inc: [views: 1]])

    Repo.transaction(fn ->
      Repo.insert(%PostsUsersViews{user_id: user_id, post_id: post_id})
      Repo.update_all(increase_query, [])
    end)
  end

  ## Tools
  def duplicate_mtm_likes() do
    users_ids = Repo.all(from u in WhyZee.Accounts.User, select: u.id)
    posts_ids = Repo.all(from p in WhyZee.Content.Post, select: p.id)
    d = DateTime.utc_now() |> DateTime.truncate(:second)

    new_records =
      Enum.zip(posts_ids, users_ids)
      |> Enum.map(fn {post_id, user_id} ->
        %{post_id: post_id, user_id: user_id, inserted_at: d, updated_at: d}
      end)

    Repo.insert_all(UsersPosts, new_records)
  end
end
