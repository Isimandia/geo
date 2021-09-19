defmodule Joffer.DbOperations.Professions do
  import Ecto.Query, warn: false
  alias Joffer.Repo
  alias Joffer.Schema.Profession

  def get_all_id() do
    from(p in Joffer.Schema.Profession,
      select: %{p.external_id => p.id}
    )
    |> Repo.all()
    |> Enum.reduce(%{}, &Map.merge(&1, &2))
  end

  def insert!(attrs) do
    %Profession{}
    |> Profession.changeset(attrs)
    |> Repo.insert!(
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: [:external_id]
    )
  end
end
