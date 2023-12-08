defmodule Rinhabackend.Events.SaveCacheConsumer do
  use GenStage

  alias Rinhabackend.Events.SaveDataProducer

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [SaveDataProducer]}
  end

  def handle_events(events, _from, state) do
    :mnesia.transaction(fn ->
      Enum.each(events, fn event ->
        Tuple.insert_at(event, 0, :pessoa)
        |> :mnesia.write()
      end)
    end)
    |> case do
      {:atomic, :ok} -> nil
      error -> IO.inspect(error, label: "insertion_error")
    end

    {:noreply, [], state}
  end
end
