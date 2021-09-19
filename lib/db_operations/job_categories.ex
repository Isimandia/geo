defmodule Joffer.DbOperations.JobCategories do
  import Ecto.Query, warn: false
  alias Joffer.Repo
  alias Joffer.Schema.JobCategory

  def insert!(attrs) do
    %JobCategory{}
    |> JobCategory.changeset(attrs)
    |> Repo.insert!(on_conflict: {:replace_all_except, [:id]}, conflict_target: [:name])
  end
end
