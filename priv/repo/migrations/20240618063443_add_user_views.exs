defmodule WhyZee.Repo.Migrations.AddUserViews do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""

    execute """
    CREATE TABLE posts_users_views(
    id          UUID           NOT NULL DEFAULT uuid_generate_v4(),
    post_id   UUID           NOT NULL REFERENCES posts(id),
    user_id   UUID           NOT NULL REFERENCES users(id),
    inserted_at TIMESTAMP      NOT NULL DEFAULT now()
    ) PARTITION BY RANGE (inserted_at)
    """

    execute "CREATE TABLE posts_users_views_default PARTITION OF posts_users_views DEFAULT"

    execute """
    CREATE TABLE posts_users_views_q1 
    PARTITION OF posts_users_views FOR VALUES
    FROM ('2024-01-01') TO ('2024-03-31')
    """

    execute """
    CREATE TABLE posts_users_views_q2 
    PARTITION OF posts_users_views FOR VALUES
    FROM ('2024-04-01') TO ('2024-06-30')
    """

    execute """
    CREATE TABLE posts_users_views_q3 
    PARTITION OF posts_users_views FOR VALUES
    FROM ('2024-07-01') TO ('2024-09-30')
    """

    execute """
    CREATE TABLE posts_users_views_q4 
    PARTITION OF posts_users_views FOR VALUES
    FROM ('2024-10-01') TO ('2024-12-31')
    """
  end

  def down do
    execute "DROP TABLE posts_users_views CASCADE"
  end
end
