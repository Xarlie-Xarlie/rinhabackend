defmodule Rinhabackend.ConsumerDatabaseEvents do
  use GenStage

  # Rinhabackend.ProducerDatabaseEvents.save_to_ets({"a"})  
  def start_link(cache_table) do
    GenStage.start_link(__MODULE__, cache_table)
  end

  def init(cache_table) do
    {:consumer, cache_table, subscribe_to: [Rinhabackend.ProducerDatabaseEvents]}
  end

  def handle_events([event], _from, cache_table) do
    :ets.delete_object(cache_table, event)
    {:noreply, [], cache_table}
  end
end
