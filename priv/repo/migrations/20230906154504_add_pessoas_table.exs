defmodule Rinhabackend.Repo.Migrations.AddPessoasTable do
  use Ecto.Migration

  def up do
    create table(:pessoas, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:apelido, :string, null: false)
      add(:nome, :string, null: false)
      add(:nascimento, :date, null: false)
      add(:stack, {:array, :string}, default: [])
      timestamps()
    end
  end

  def down do
    drop table(:pessoas)
  end
end
