defmodule Rinhabackend.Events.SaveDbConsumer do
  use GenStage

  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.Repo
  alias Rinhabackend.Events.SaveDataProducer

  def start_link(_) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [SaveDataProducer]}
  end

  def handle_events(events, _from, state) do
    Enum.map(events, fn {id, name, nickname, birthday, stack, indexed_text} ->
      now =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.truncate(:second)

      %{
        id: id,
        nome: name,
        apelido: nickname,
        nascimento: birthday,
        stack: stack,
        text: indexed_text,
        inserted_at: now,
        updated_at: now
      }
    end)
    |> then(
      &Repo.insert_all(Pessoa, &1, on_conflict: :nothing, conflict_target: :id, returning: false)
    )

    {:noreply, [], state}
  end
end
