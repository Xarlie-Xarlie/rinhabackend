defmodule Rinhabackend.Pessoas.Query do
  @moduledoc """
  Query action for %Pessoa{}.
  """

  alias Rinhabackend.Pessoas.Pessoa

  @doc "Query a %Pessoa{} in database"
  @spec call(binary()) :: [Pessoa.t()]
  def call(""), do: []

  def call(query_string) do
    query_string = String.downcase(query_string)

    :mnesia.transaction(fn ->
      :mnesia.foldr(
        fn {id, name, nickname, birthday, stack, indexed_fields}, acc ->
          if String.contains?(indexed_fields, query_string) do
            [
              %Pessoa{id: id, nome: name, apelido: nickname, nascimento: birthday, stack: stack}
              | acc
            ]
          else
            acc
          end
        end,
        [],
        :pessoa
      )
    end)
    |> case do
      {:atomic, result} ->
        result

      _ ->
        []
    end
  end
end
