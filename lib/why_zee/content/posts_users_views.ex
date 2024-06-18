defmodule WhyZee.Content.PostsUsersViews do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhyZee.Content.Post
  alias WhyZee.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts_users_views" do
    belongs_to :user, User
    belongs_to :post, Post
    field :inserted_at, :utc_datetime
  end

  @doc false
  def changeset(user_post, attrs) do
    user_post
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
  end
end
