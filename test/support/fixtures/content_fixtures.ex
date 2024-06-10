defmodule WhyZee.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WhyZee.Content` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body",
        likes: 42,
        title: "some title",
        views: 42
      })
      |> WhyZee.Content.create_post()

    post
  end
end
