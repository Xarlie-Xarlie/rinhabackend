defmodule Rinhabackend.Pessoas.Query do
  @moduledoc """
  Query action for %Pessoa{}.
  """

  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.Repo
  import Ecto.Query

  @doc "Query a %Pessoa{} in database"
  @spec call(binary()) :: [Pessoa.t()]
  def call(""), do: []

  def call(query_string) do
    from(p in Pessoa,
      where:
        fragment(
          "text % ?",
          ^query_string
        )
    )
    |> Repo.all()
  end
end
