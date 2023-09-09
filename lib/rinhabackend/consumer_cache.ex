defmodule Rinhabackend.ConsumerDatabaseEvents do
  use GenStage

  alias Rinhabackend.Repo
  alias Rinhabackend.Pessoas.Pessoa

  def start_link(cache_table) do
    GenStage.start_link(__MODULE__, cache_table)
  end

  def init(cache_table) do
    {:consumer, cache_table, subscribe_to: [Rinhabackend.ProducerDatabaseEvents]}
  end

  def handle_events([{id, apelido, nome, nascimento, stack} = event], _from, cache_table) do
    %Pessoa{id: id, apelido: apelido, nome: nome, nascimento: nascimento, stack: stack}
    |> Repo.insert()
    |> case do
      {:ok, %Pessoa{}} -> :ets.delete_object(cache_table, event)
      error -> error
    end

    {:noreply, [], cache_table}
  end
end
