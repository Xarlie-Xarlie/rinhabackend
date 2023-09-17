defmodule Rinhabackend.Pessoas.Create do
  @moduledoc """
  Create action for %Pessoa{}.
  """

  alias Ecto.Changeset
  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.ProduceSaveEvents

  @doc "Create a new %Pessoa{} in database"
  @spec call(map()) :: {:ok, Pessoa.t()} | {:error, Changeset.t()}
  def call(params) do
    Pessoa.changeset(params)
    |> create_event()
  end

  defp create_event(%Changeset{valid?: false} = changeset), do: {:error, changeset}

  defp create_event(%Changeset{changes: changes}) do
    id = Map.get(changes, :id, "")
    apelido = Map.get(changes, :apelido, "")
    nascimento = Map.get(changes, :nascimento, "")
    nome = Map.get(changes, :nome, "")
    stack = Map.get(changes, :stack, [])

    ProduceSaveEvents.sync_notify({id, apelido, nome, nascimento, stack})
    {:ok, %Pessoa{id: id, apelido: apelido, nome: nome, nascimento: nascimento, stack: stack}}
  end
end
