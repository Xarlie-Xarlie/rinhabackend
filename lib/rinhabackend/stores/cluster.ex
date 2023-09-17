defmodule Rinhabackend.Stores.Cluster do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, Node.list(), name: __MODULE__)
  end

  @impl true
  def init(state) do
    Mnesiac.init_mnesia(Node.list())
    {:ok, state}
  end

  def children_spec do
    case Application.get_env(:libcluster, :topologies) do
      nil ->
        nil

      topologies ->
        hosts = get_in(topologies, [:rinhabackend, :config, :hosts]) || []

        [
          {Cluster.Supervisor, [topologies, [name: Rinhabackend.ClusterSupervisor]]},
          {Mnesiac.Supervisor, [hosts, [name: Rinhabackend.MnesiacSupervisor]]}
        ]
    end
  end
end
