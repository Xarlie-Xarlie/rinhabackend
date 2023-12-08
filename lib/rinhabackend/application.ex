defmodule Rinhabackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RinhabackendWeb.Telemetry,
      # Start the Ecto repository
      Rinhabackend.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Rinhabackend.PubSub},
      # Start the Endpoint (http/https)
      RinhabackendWeb.Endpoint,
      # Start a worker by calling: Rinhabackend.Worker.start_link(arg)
      {Rinhabackend.Events.SaveDataProducer, 0},
      # {Rinhabackend.Events.SaveCacheConsumer, :ok},
      {Rinhabackend.Events.SaveDbConsumer, :ok}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: Rinhabackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RinhabackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
