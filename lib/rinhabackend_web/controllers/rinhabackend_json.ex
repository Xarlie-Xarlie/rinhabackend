defmodule RinhabackendWeb.RinhabackendJSON do
  alias Rinhabackend.Pessoas.Pessoa

  def create(%{
        pessoa: %Pessoa{nome: nome, apelido: apelido, nascimento: nascimento, stack: stack}
      }) do
    %{nome: nome, apelido: apelido, nascimento: nascimento, stack: stack}
  end

  def show(%{
        pessoa: %Pessoa{
          id: id,
          nome: nome,
          apelido: apelido,
          nascimento: nascimento,
          stack: stack
        }
      }) do
    %{id: id, nome: nome, apelido: apelido, nascimento: nascimento, stack: stack}
  end

  def show(%{pessoas: pessoas}) do
    Enum.map(pessoas, &Map.take(&1, [:id, :nome, :apelido, :nascimento, :stack]))
  end

  def count(%{number_of_people: number_of_people}), do: %{qty_pessoas: number_of_people}
end
