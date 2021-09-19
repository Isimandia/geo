defmodule Joffer.Repo.Migrations.ContractTypes do
  use Ecto.Migration

  def change do
    create table(:contract_types) do
      add :name, :string, null: false
    end
    create unique_index(:contract_types, [:name])

  end
end
