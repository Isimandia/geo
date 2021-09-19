defmodule Joffer.DbOperations.Aggregates do
  import Ecto.Query, warn: false
  alias Joffer.Repo
  alias Joffer.Schema.Aggregate
  alias Joffer.Schema.JobOffer

  def fill_table!() do
    from(a in Aggregate)
    |> Repo.delete_all()

    from(j in JobOffer,
      join: jc in assoc(j, :job_category),
      select: %{
        job_category_id: jc.id,
        continent_id: j.continent_id,
        amount: count(j.id)
      },
      group_by: [jc.id, j.continent_id]
    )
    |> Repo.all()
    |> Enum.each(
      &(%Aggregate{}
        |> Aggregate.changeset(&1)
        |> Repo.insert!())
    )
  end

  def select_all_aggregates() do
    from(a in Aggregate,
      join: c in assoc(a, :continent),
      join: j in assoc(a, :job_category),
      preload: [:continent, :job_category]
    )
    |> Repo.all()
  end
end
