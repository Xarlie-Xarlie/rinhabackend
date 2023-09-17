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
    :mnesia.transaction(fn ->
      :mnesia.foldr(
        fn {id, name, nickname, birthday, stack}, acc ->
          String.contains?(
            String.downcase(name),
            String.downcase(query_string)
          ) or
            String.contains?(
              String.downcase(nickname),
              String.downcase(query_string)
            )
            |> if do
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
        from(p in Pessoa, where: ^query_string in p.stack, limit: 50)
        |> Repo.all()
    end
  end
end
