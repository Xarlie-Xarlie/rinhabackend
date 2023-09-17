defmodule Rinhabackend.Pessoas.Get do
  @moduledoc """
  Get action for %Pessoa{}.
  """

  alias Rinhabackend.Pessoas.Pessoa

  @doc "Get a %Pessoa{} in database"
  @spec call(map()) :: Pessoa.t() | nil
  def call(person_id) do
    case Ecto.UUID.cast(person_id) do
      {:ok, valid_person_id} -> get_person(valid_person_id)
      :error -> nil
    end
  end

  defp get_person(valid_person_id) do
    :mnesia.dirty_read({:pessoa, valid_person_id})
    |> case do
      [{:pessoa, id, apelido, nome, nascimento, stack}] ->
        %Pessoa{id: id, apelido: apelido, nome: nome, nascimento: nascimento, stack: stack}

      [] ->
        nil
    end
  end
end
