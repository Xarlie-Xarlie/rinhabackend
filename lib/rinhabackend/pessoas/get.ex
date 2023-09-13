defmodule Rinhabackend.Pessoas.Get do
  @moduledoc """
  Get action for %Pessoa{}.
  """

  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.Repo

  @read_cache Application.compile_env!(:rinhabackend, :read_cache)
  @write_cache Application.compile_env!(:rinhabackend, :write_cache)

  @doc "Get a %Pessoa{} in database"
  @spec call(map()) :: Pessoa.t() | nil
  def call(person_id) do
    case Ecto.UUID.cast(person_id) do
      {:ok, valid_person_id} -> get_person(valid_person_id)
      :error -> nil
    end
  end

  defp get_person(valid_person_id) do
    read_from_cache = :ets.lookup(@read_cache, valid_person_id)
    read_from_write_cache = :ets.lookup(@write_cache, valid_person_id)
    cache_in_connected_nodes = get_cache_from_connect_nodes(valid_person_id)

    person =
      cond do
        read_from_cache != [] -> read_from_cache
        read_from_write_cache != [] -> read_from_write_cache
        cache_in_connected_nodes != [] -> cache_in_connected_nodes
        true -> Repo.get(Pessoa, valid_person_id)
      end

    case person do
      %Pessoa{id: id, apelido: apelido, nome: nome, nascimento: nascimento, stack: stack} ->
        :ets.insert(@read_cache, {id, apelido, nome, nascimento, stack})
        person

      [{id, apelido, nome, nascimento, stack}] ->
        %Pessoa{id: id, apelido: apelido, nome: nome, nascimento: nascimento, stack: stack}

      nil ->
        nil
    end
  end

  defp get_cache_from_connect_nodes(valid_person_id) do
    Node.connect(:rinhabackend@api1)
    Node.connect(:rinhabackend@api2)

    pid = self()

    Node.list()
    |> Enum.map(
      &Node.spawn(&1, fn ->
        send(pid, [
          :ets.lookup(@read_cache, valid_person_id),
          :ets.lookup(@write_cache, valid_person_id)
        ])
      end)
    )

    receive do
      [result, _] when result != [] ->
        result

      [_, result] when result != [] ->
        result
    after
      1000 ->
        []
    end
  end
end
