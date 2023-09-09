defmodule Rinhabackend.ProducerDatabaseEvents do
  use GenStage

  def start_link(cache_table) do
    GenStage.start_link(__MODULE__, cache_table, name: __MODULE__)
  end

  def init(cache_table), do: {:producer, cache_table}

  def save_to_ets(attrs) do
    GenStage.cast(__MODULE__, {:save_to_ets, attrs})
  end

  def handle_cast({:save_to_ets, attrs}, cache_table) do
    :ets.insert(cache_table, attrs)
    {:noreply, [attrs], cache_table}
  end

  def handle_demand(demand, cache_table) when demand > 0 do
    events = :ets.tab2list(cache_table)
    {:noreply, events, cache_table}
  end
end
