defmodule RinhabackendWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".

  alias Ecto.Changeset

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def bad_request(%{message: message}), do: %{message: message}

  def not_found(_), do: nil

  def not_valid_entity(%{changeset: changeset}) do
    %{errors: Changeset.traverse_errors(changeset, &translate_errors/1)}
  end

  @spec translate_errors(tuple()) :: binary()
  defp translate_errors({msg, opts}) do
    Regex.replace(~r/%{(\w+)}/, msg, fn _, key ->
      opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
    end)
  end
end
