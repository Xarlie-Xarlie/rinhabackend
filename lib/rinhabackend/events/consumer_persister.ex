defmodule Rinhabackend.Events.ConsumerPersister do
  use GenStage

  alias Rinhabackend.Repo
  alias Rinhabackend.Pessoas.Pessoa

  def start_link(_opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [Rinhabackend.Events.ProducerSave]}
  end

  def handle_events([event], _from, state) do
    {id, nome, apelido, nascimento, stack, text} = event

    now =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    %Pessoa{
      id: id,
      apelido: apelido,
      nome: nome,
      nascimento: nascimento,
      stack: stack,
      text: text,
      inserted_at: now,
      updated_at: now
    }
    |> Repo.insert(
      on_conflict: :nothing,
      conflict_target: :id,
      returning: true
    )

    {:noreply, [], state}
  end
end
