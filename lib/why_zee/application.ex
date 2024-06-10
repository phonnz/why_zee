defmodule WhyZee.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WhyZeeWeb.Telemetry,
      WhyZee.Repo,
      {DNSCluster, query: Application.get_env(:why_zee, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WhyZee.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WhyZee.Finch},
      # Start a worker by calling: WhyZee.Worker.start_link(arg)
      # {WhyZee.Worker, arg},
      # Start to serve requests, typically the last entry
      WhyZeeWeb.Endpoint,
      {Oban, Application.fetch_env!(:why_zee, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WhyZee.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WhyZeeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
