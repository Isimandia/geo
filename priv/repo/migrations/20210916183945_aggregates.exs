defmodule Joffer.Repo.Migrations.Aggregates do
  use Ecto.Migration

  def change do
      create table(:aggregates) do
        add :continent_id, references(:continents, on_delete: :nothing)
        add :job_category_id, references(:job_categories, on_delete: :nothing)
        add :amount, :integer
      end

      create unique_index(:aggregates, [:job_category_id, :continent_id])
  end
end

