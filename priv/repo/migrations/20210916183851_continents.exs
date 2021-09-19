defmodule Joffer.Repo.Migrations.Continents do
  use Ecto.Migration

  def change do
    create table(:continents) do
      add :name, :string, null: false
      add :polygon, :geography, null: false
    end
  end
end
