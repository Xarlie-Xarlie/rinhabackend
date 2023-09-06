defmodule Rinhabackend.Pessoas.Create do
  @moduledoc """
  Create action for %Pessoa{}.
  """

  alias Ecto.Changeset
  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.Repo

  @doc "Create a new %Pessoa{} in database"
  @spec call(map()) :: {:ok, Pessoa.t()} | {:error, Changeset.t()}
  def call(params) do
    Pessoa.changeset(params)
    |> Repo.insert()
  end
end
