defmodule Autheer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # AutheerWeb.Telemetry,
      # {DNSCluster, query: Application.get_env(:autheer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Autheer.PubSub},
      # Start a worker by calling: Autheer.Worker.start_link(arg)
      # {Autheer.Worker, arg},
      # Start to serve requests, typically the last entry
      AutheerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Autheer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AutheerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
