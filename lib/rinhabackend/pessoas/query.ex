defmodule Rinhabackend.Pessoas.Query do
  @moduledoc """
  Query action for %Pessoa{}.
  """

  alias Rinhabackend.Pessoas.Pessoa
  import Ecto.Query
  alias Rinhabackend.Repo

  @doc "Query a %Pessoa{} in database"
  @spec call(map()) :: [Pessoa.t()]
  def call(""), do: []

  def call(query_string) do
    from(p in Pessoa,
      where:
        ilike(p.nome, ^query_string) or
          ilike(p.apelido, ^query_string) or
          ^query_string in p.stack,
      limit: 50
    )
    |> Repo.all()
  end
end
