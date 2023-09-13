defmodule Rinhabackend.ProducerDatabaseEvents do
  use GenStage

  @read_cache Application.compile_env!(:rinhabackend, :read_cache)

  def start_link(cache_table) do
    Node.connect(:rinhabackend@api1)
    Node.connect(:rinhabackend@api2)
    GenStage.start_link(__MODULE__, cache_table, name: __MODULE__)
  end

  def init(cache_table), do: {:producer, cache_table}

  def save_to_ets(attrs) do
    GenStage.cast(__MODULE__, {:save_to_ets, attrs})
  end

  def handle_cast({:save_to_ets, attrs}, cache_table) do
    :ets.insert(cache_table, attrs)
    :ets.insert(@read_cache, attrs)

    events =
      :ets.info(cache_table)
      |> Keyword.get(:size)
      |> case do
        size when size < 250 -> []
        _ -> :ets.tab2list(cache_table)
      end

    {:noreply, events, cache_table}
  end

  def handle_demand(demand, cache_table) when demand > 0 do
    {:noreply, [], cache_table}
  end
end
