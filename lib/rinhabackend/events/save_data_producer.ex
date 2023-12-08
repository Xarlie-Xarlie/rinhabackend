defmodule Rinhabackend.Events.SaveDataProducer do
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    Process.send_after(self(), :tick, 2000)

    {:producer, {:queue.new(), 0}, dispatcher: GenStage.BroadcastDispatcher, buffer_size: 100_000}
  end

  # def save(event) do
  #   GenStage.cast(__MODULE__, event)
  # end

  def save(event) do
    GenStage.cast(__MODULE__, event)
  end

  def handle_call(event, from, {queue, pending_demand}) do
    queue = :queue.in(event, queue)
    GenStage.reply(from, :ok)

    {:noreply, [], {queue, pending_demand}}
  end

  def handle_cast(event, {queue, pending_demand}) do
    {:noreply, [], {:queue.in(event, queue), pending_demand}}
  end

  def handle_info(:tick, {queue, pending_demand}) do
    IO.puts("handle info nessa porra")
    Process.send_after(self(), :tick, 2000)

    dispatch_events(queue, pending_demand, [])
  end

  def handle_demand(incoming_demand, {queue, pending_demand}) do
    dispatch_events(queue, incoming_demand + pending_demand, [])
  end

  defp dispatch_events(queue, 0, events) do
    {:noreply, Enum.reverse(events), {queue, 0}}
  end

  defp dispatch_events(queue, demand, events) do
    case :queue.out(queue) do
      {{:value, event}, queue} ->
        dispatch_events(queue, demand - 1, [event | events])

      {:empty, queue} ->
        {:noreply, Enum.reverse(events), {queue, demand}}
    end
  end
end
