defmodule Joffer.Repo.Migrations.Professions do
  use Ecto.Migration

  def change do
    create table(:professions) do
      add :name, :string, null: false
      add :external_id, :string
      add :job_category_id, references(:job_categories, on_delete: :nothing)
    end

    create unique_index(:professions, [:external_id])
  end
end
