defmodule Rinhabackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @write_cache Application.compile_env!(:rinhabackend, :write_cache)
  @read_cache Application.compile_env!(:rinhabackend, :read_cache)

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
      %{
        id: @write_cache,
        start: {Eternal, :start_link, [@write_cache, [:compressed], [quiet: true]]}
      },
      %{
        id: @read_cache,
        start: {Eternal, :start_link, [@read_cache, [:compressed], [quiet: true]]}
      },
      {Rinhabackend.ProducerDatabaseEvents, @write_cache},
      Supervisor.child_spec({Rinhabackend.ConsumerDatabaseEvents, @write_cache}, id: :c1),
      Supervisor.child_spec({Rinhabackend.ConsumerDatabaseEvents, @write_cache}, id: :c2),
      Supervisor.child_spec({Rinhabackend.ConsumerDatabaseEvents, @write_cache}, id: :c3),
      Supervisor.child_spec({Rinhabackend.ConsumerDatabaseEvents, @write_cache}, id: :c4)
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
