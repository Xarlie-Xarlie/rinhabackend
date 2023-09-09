defmodule RinhabackendWeb.RinhabackendController do
  use RinhabackendWeb, :controller

  alias Rinhabackend.Pessoas
  alias Rinhabackend.Pessoas.Pessoa
  alias RinhabackendWeb.ErrorJSON

  def create(conn, params) do
    case Pessoas.create_person(params) do
      {:ok, pessoa} ->
        conn
        |> put_status(:created)
        |> put_resp_header("Location", "/pessoas/#{pessoa.id}")
        |> render(:create, pessoa: pessoa)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: ErrorJSON)
        |> render(:not_valid_entity, changeset: changeset)
    end
  end

  def show(conn, %{"id" => person_id}) do
    case Pessoas.get_person(person_id) do
      %Pessoa{} = pessoa ->
        conn
        |> put_status(:ok)
        |> render(:show, pessoa: pessoa)

      nil ->
        conn
        |> put_view(json: ErrorJSON)
        |> put_status(:not_found)
        |> render(:not_found)
    end
  end

  def query(conn, %{"t" => query_string}) do
    pessoas = Pessoas.query_people(query_string)

    conn
    |> put_status(:ok)
    |> render(:show, pessoas: pessoas)
  end

  def query(conn, _invalid_params) do
    conn
    |> put_view(json: ErrorJSON)
    |> put_status(:bad_request)
    |> render(:bad_request, message: "You should pass '?t=YOUR_TEXT' as params")
  end

  def count(conn, _) do
    number_of_people = Pessoas.count_people()

    conn
    |> put_status(:ok)
    |> render(:count, number_of_people: number_of_people)
  end
end
