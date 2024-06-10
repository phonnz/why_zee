defmodule WhyZee.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :title, :string
    field :body, :string
    field :views, :integer, default: 0
    field :likes, :integer, default: 0
    #field :user_id, :binary_id

    belongs_to :user, WhyZee.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :views, :likes])
    |> validate_required([:title, :body])
  end
end
