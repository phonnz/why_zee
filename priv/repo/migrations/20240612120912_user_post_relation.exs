defmodule WhyZee.Repo.Migrations.UserPostRelation do
  use Ecto.Migration

  def change do
    create table(:users_posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :post_id, references(:posts, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:users_posts, [:user_id, :post_id])
  end
end
