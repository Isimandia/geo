defmodule Joffer.Repo.Migrations.JobCategories do
  use Ecto.Migration
  def change do

    create table(:job_categories) do
      add :name, :string, null: false
    end

    create unique_index(:job_categories, [:name])
  end
end
