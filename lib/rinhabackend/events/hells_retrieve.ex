defmodule Rinhabackend.Events.HellsRetrieve do
  alias Rinhabackend.Pessoas.Pessoa
  alias Rinhabackend.Repo
  import Ecto.Query

  def start_link({query_string, pid}) do
    Task.start_link(fn ->
      query =
        from(p in Pessoa, where: ilike(p.text, ^"%#{query_string}%"), limit: 50)
        |> Repo.all()

      send(pid, query)
    end)
  end
end
