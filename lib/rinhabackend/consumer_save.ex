defmodule Rinhabackend.ConsumerSaveEvents do
  use GenStage

  alias Rinhabackend.Repo
  alias Rinhabackend.Pessoas.Pessoa

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [Rinhabackend.ProduceSaveEvents]}
  end

  def handle_events(events, _from, state) do
    for {id, nome, apelido, nascimento, stack} <- events do
      now =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)

      %{
        id: id,
        apelido: apelido,
        nome: nome,
        nascimento: nascimento,
        stack: stack,
        inserted_at: now,
        updated_at: now
      }
    end
    |> then(
      &Repo.insert_all(Pessoa, &1,
        on_conflict: :nothing,
        conflict_target: :id,
        returning: true
      )
    )

    {:noreply, [], state}
  end
end
