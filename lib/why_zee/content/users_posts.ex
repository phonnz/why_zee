defmodule WhyZee.Content.UsersPosts do
  use Ecto.Schema
  import Ecto.Changeset
  alias WhyZee.Content.Post
  alias WhyZee.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users_posts" do
    belongs_to :user, User
    belongs_to :post, Post

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_post, attrs) do
    user_post
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
  end
end
