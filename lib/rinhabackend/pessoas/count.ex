defmodule Rinhabackend.Pessoas.Count do
  @moduledoc """
  Count People action for %Pessoa{}.
  """
  import Ecto.Query
  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.Repo

  @doc "Count the number of %Pessoa{} in database"
  @spec call() :: integer()
  def call() do
    from(p in Pessoa, select: fragment("count(*)"))
    |> Repo.one()
  end
end
