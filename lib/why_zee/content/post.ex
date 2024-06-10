defmodule WhyZee.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :title, :string
    field :body, :string
    field :views, :integer
    field :likes, :integer
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :views, :likes])
    |> validate_required([:title, :body, :views, :likes])
  end
end
