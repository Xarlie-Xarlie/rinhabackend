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

  def handle_events(events, _from, cache_table) do
    Enum.map(events, fn {id, apelido, nome, nascimento, stack} ->
      now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

      %{
        id: id,
        apelido: apelido,
        nome: nome,
        nascimento: nascimento,
        stack: stack,
        inserted_at: now,
        updated_at: now
      }
    end)
    |> then(
      &Repo.insert_all(Pessoa, &1,
        on_conflict: :nothing,
        conflict_target: :id,
        returning: true
      )
    )

    Enum.map(events, &:ets.delete_object(cache_table, &1))

    {:noreply, [], cache_table}
  end
end
