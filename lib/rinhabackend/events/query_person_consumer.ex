defmodule Rinhabackend.Events.QueryPersonConsumer do
  use GenStage

  def start_link(_arg) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [{QueryPersonProducer, max_demand: 50}]}
  end

  def handle_events(_, _, state), do: {:noreply, [], state}
end
