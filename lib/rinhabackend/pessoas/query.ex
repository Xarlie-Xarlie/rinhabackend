defmodule Rinhabackend.Pessoas.Query do
  @moduledoc """
  Query action for %Pessoa{}.
  """

  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.Events.QueryCall

  @doc "Query a %Pessoa{} in database"
  @spec call(binary()) :: [Pessoa.t()]
  def call(""), do: []

  def call(query_string) do
    query_string = String.downcase(query_string)

    pid = self()
    QueryCall.query(query_string, pid)

    receive do
      result -> result
    after
      45000 ->
        IO.puts("demorou")
        []
    end
  end
end
