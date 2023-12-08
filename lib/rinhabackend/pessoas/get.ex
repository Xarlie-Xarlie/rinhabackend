defmodule Rinhabackend.Pessoas.Get do
  @moduledoc """
  Get action for %Pessoa{}.
  """

  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.Repo

  @doc "Get a %Pessoa{} in database"
  @spec call(map()) :: Pessoa.t() | nil
  def call(person_id) do
    case Ecto.UUID.cast(person_id) do
      {:ok, valid_person_id} -> get_person(valid_person_id)
      :error -> nil
    end
  end

  defp get_person(valid_person_id) do
    Repo.get_by(Pessoa, id: valid_person_id)
  end
end
