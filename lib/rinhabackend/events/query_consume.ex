defmodule Rinhabackend.Events.QueryConsume do
  use ConsumerSupervisor

  alias Rinhabackend.Events.HellsRetrieve
  alias Rinhabackend.Events.QueryCall

  def start_link(arg) do
    ConsumerSupervisor.start_link(__MODULE__, arg)
  end

  def init(arg) do
    # Note: By default the restart for a child is set to :permanent
    # which is not supported in ConsumerSupervisor. You need to explicitly
    # set the :restart option either to :temporary or :transient.
    children = [
      %{id: arg, start: {HellsRetrieve, :start_link, []}, restart: :transient}
    ]

    opts = [strategy: :one_for_one, subscribe_to: [{QueryCall, max_demand: 50}]]
    ConsumerSupervisor.init(children, opts)
  end
end

# defmodule Rinhabackend.QueryConsume do
#   use GenStage

#   alias Rinhabackend.Pessoas.Pessoa
#   alias Rinhabackend.Repo
#   import Ecto.Query

#   def start_link(_opts) do
#     GenStage.start_link(__MODULE__, :ok)
#   end

#   def init(:ok) do
#     {:consumer, :ok, subscribe_to: [Rinhabackend.QueryCall]}
#   end

#   def handle_events([{query_string, pid}], _from, state) do
#     query =
#       from(p in Pessoa, where: ilike(p.text, ^"%#{query_string}%"), limit: 50)
#       |> Repo.all()

#     send(pid, query)

#     {:noreply, [], state}
#   end

#   def handle_events(events, _from, state) do
#     IO.puts("porra")

#     for {query_string, pid} <- events do
#       query =
#         from(p in Pessoa, where: ilike(p.text, ^"%#{query_string}%"), limit: 50)
#         |> Repo.all()

#       send(pid, query)
#     end

#     {:noreply, [], state}
#   end
# end
