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
      {Rinhabackend.Events.QueryCall, :ok},
      {Rinhabackend.Events.ProducerSave, 0},
      %{id: :c1, start: {Rinhabackend.Events.ConsumerPersister, :start_link, [:ok]}},
      %{id: :c2, start: {Rinhabackend.Events.ConsumerCache, :start_link, [:ok]}},
      %{id: :q1, start: {Rinhabackend.Events.QueryConsume, :start_link, [:q1]}},
      %{id: :q2, start: {Rinhabackend.Events.QueryConsume, :start_link, [:q2]}},
      %{id: :q3, start: {Rinhabackend.Events.QueryConsume, :start_link, [:q3]}}
    ]

    children =
      case Rinhabackend.Stores.Cluster.children_spec() do
        nil -> children
        children_spec -> children ++ children_spec
      end

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
