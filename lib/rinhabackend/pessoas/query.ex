defmodule Rinhabackend.Pessoas.Query do
  @moduledoc """
  Query action for %Pessoa{}.
  """

  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.Repo
  import Ecto.Query
  @write_cache Application.compile_env!(:rinhabackend, :write_cache)
  @read_cache Application.compile_env!(:rinhabackend, :read_cache)

  @doc "Query a %Pessoa{} in database"
  @spec call(binary()) :: [Pessoa.t()]
  def call(""), do: []

  def call(query_string) do
    read_cache = query_person_in_ets(query_string, @read_cache)
    write_cache = query_person_in_ets(query_string, @write_cache)
    node_cache = get_cache_from_connect_nodes(query_string)

    cond do
      read_cache != [] ->
        Enum.take(read_cache, 50)
        |> Enum.map(fn {id, nome, apelido, nascimento, stack} ->
          %Pessoa{id: id, nome: nome, apelido: apelido, nascimento: nascimento, stack: stack}
        end)

      write_cache != [] ->
        Enum.take(write_cache, 50)
        |> Enum.map(fn {id, nome, apelido, nascimento, stack} ->
          %Pessoa{id: id, nome: nome, apelido: apelido, nascimento: nascimento, stack: stack}
        end)

      node_cache != [] ->
        Enum.take(node_cache, 50)
        |> Enum.map(fn {id, nome, apelido, nascimento, stack} ->
          %Pessoa{id: id, nome: nome, apelido: apelido, nascimento: nascimento, stack: stack}
        end)

      true ->
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

  defp get_cache_from_connect_nodes(query_string) do
    Node.connect(:rinhabackend@api1)
    Node.connect(:rinhabackend@api2)

    pid = self()

    Node.list()
    |> Enum.map(
      &Node.spawn(&1, fn ->
        send(
          pid,
          [
            query_person_in_ets(query_string, @read_cache),
            query_person_in_ets(query_string, @write_cache)
          ]
        )
      end)
    )

    receive do
      [result, _] when result != [] -> result
      [_, result] when result != [] -> result
    after
      1000 ->
        []
    end
  end

  defp query_person_in_ets(query_string, table) do
    :ets.foldl(
      fn
        {_, name, nickname, _, stack} = row, [] = acc ->
          name = String.downcase(name)
          nickname = String.downcase(nickname)
          stack = Enum.map(stack, &String.downcase/1)
          query_string = String.downcase(query_string)

          (String.contains?(name, query_string) or
             String.contains?(nickname, query_string) or
             query_string in stack)
          |> if do
            [row | acc]
          else
            acc
          end

        _, acc ->
          acc
      end,
      [],
      table
    )
  end
end
