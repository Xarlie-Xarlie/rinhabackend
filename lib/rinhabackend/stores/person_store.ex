defmodule Rinhabackend.Stores.PersonStore do
  use Mnesiac.Store

  import Record, only: [defrecord: 3]
  require Logger

  defrecord(
    :pessoa,
    :pessoa,
    id: nil,
    nome: nil,
    apelido: nil,
    nascimento: nil,
    stack: [],
    indexed: nil
  )

  @type pessoa ::
          record(
            :pessoa,
            id: String.t(),
            nome: String.t(),
            apelido: String.t(),
            nascimento: NaiveDateTime.t(),
            stack: [String.t()],
            indexed: String.t()
          )
  @impl true
  def store_options do
    [
      record_name: :pessoa,
      attributes: pessoa() |> pessoa() |> Keyword.keys(),
      index: [],
      disc_copies: [node()]
    ]
  end

  @impl true
  def resolve_conflict(node) do
    Logger.warn("RESOLVE CONFLICT #{inspect(node())} vs #{inspect(node)}")

    copy_store()
  end
end
