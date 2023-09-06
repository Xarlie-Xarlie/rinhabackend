defmodule Rinhabackend.Pessoas do
  @moduledoc """
  Pessoas wrapper.
  """
  alias Rinhabackend.Pessoas.Query
  alias Rinhabackend.Pessoas.Get
  alias Rinhabackend.Pessoas.Create
  alias Rinhabackend.Pessoas.Count

  defdelegate create_person(params), to: Create, as: :call
  defdelegate get_person(person_id), to: Get, as: :call
  defdelegate query_people(query_string), to: Query, as: :call
  defdelegate count_people, to: Count, as: :call
end
