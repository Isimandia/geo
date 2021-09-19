defmodule Joffer.Repo.Migrations.JobOffers do
  use Ecto.Migration

  def change do
    create table(:job_offers) do
      add :name, :string, null: false
      add :contract_type_id, references(:contract_types, on_delete: :nothing)
      add :office_point, :geography
      add :profession_id, references(:professions, on_delete: :nothing)
      add :continent_id, references(:continents, on_delete: :nothing)
    end

    create unique_index(:job_offers, [:name, :contract_type_id, :office_point])
  end
end
