defmodule Rinhabackend.Pessoas.Pessoa do
  @moduledoc """
  Pessoa's Struct.

  ### Validate all fields.
   - nascimento must be a date string.
   - stack must be an array of strings.

  ### Fields:
  %#{__MODULE__}{
    apelido: string.
    nome: string.
    nascimento: string with format of date (0000-00-00).
    stack: array of strings (["Elixir", "Phoenix"])
  }
  """
  use Ecto.Schema

  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :apelido, :nome, :stack]}

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "pessoas" do
    field(:apelido, :string)
    field(:nome, :string)
    field(:stack, {:array, :string}, default: [])
    field(:nascimento, :date)
    field(:text, :string)
    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, [:apelido, :nome, :stack, :nascimento, :text])
    |> validate_required([:apelido, :nome, :stack, :nascimento])
    |> validate_length(:apelido, max: 32)
    |> validate_length(:nome, max: 100)
    |> validate_change(:stack, &validate_stack/2)
    |> change(%{id: Ecto.UUID.generate()})
  end

  @spec validate_stack(atom(), [binary()]) :: keyword()
  defp validate_stack(:stack, stack) do
    if Enum.all?(stack, &is_binary/1) do
      []
    else
      [stack: {"Only accepts strings", []}]
    end
  end
end
