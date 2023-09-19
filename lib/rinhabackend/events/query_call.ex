defmodule Rinhabackend.Events.QueryCall do
  @moduledoc """
  Broadcasts events to consumers.

  Take any post of 'pessoas' and save it in buffers.
  """
  use GenStage

  @doc "Starts the broadcaster."
  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc "Sends an event and returns only after the event is dispatched."
  def query(query_string, pid) do
    GenStage.cast(__MODULE__, {:query, query_string, pid})
  end

  def init(:ok) do
    {:producer, :ok, dispatcher: GenStage.DemandDispatcher}
  end

  def handle_cast({:query, query_string, pid}, :ok) do
    {:noreply, [{query_string, pid}], :ok}
  end

  def handle_demand(_incoming_demand, :ok) do
    {:noreply, [], :ok}
  end
end
