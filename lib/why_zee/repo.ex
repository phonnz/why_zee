defmodule WhyZee.Repo do
  use Ecto.Repo,
    otp_app: :why_zee,
    adapter: Ecto.Adapters.Postgres
end
