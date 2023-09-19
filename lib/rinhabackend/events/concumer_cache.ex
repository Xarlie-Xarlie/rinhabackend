defmodule Rinhabackend.Events.ConsumerCache do
  use GenStage

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    # {:consumer, [], subscribe_to: [Rinhabackend.Events.ProducerSave]}
    {:consumer, []}
  end

  def handle_events([event], _from, state) do
    IO.inspect(event)

    :mnesia.transaction(fn ->
      Tuple.insert_at(event, 0, :pessoa)
      |> :mnesia.write()
    end)
    |> case do
      {:atomic, :ok} ->
        {:noreply, [], state}

      error ->
        IO.inspect(error, label: "insert_failed")
        {:noreply, [], [event | state]}
    end
  end
end
