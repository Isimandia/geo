defmodule Joffer.DbOperations.ContractTypes do
  import Ecto.Query, warn: false
  alias Joffer.Repo
  alias Joffer.Schema.ContractType

  def insert!(attrs) do
    %ContractType{}
    |> ContractType.changeset(attrs)
    |> Repo.insert!(on_conflict: {:replace_all_except, [:id]}, conflict_target: [:name])
  end
end
