defmodule Joffer.DbOperations.JobOffers do
  import Ecto.Query, warn: false
  alias Joffer.Repo
  alias Joffer.Schema.JobOffer
  alias Joffer.Schema.Continent

  def insert!(attrs) do
    %JobOffer{}
    |> JobOffer.changeset(attrs)
    |> Repo.insert!(
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: [:name, :contract_type_id, :office_point]
    )
  end

  def update_regions() do
    data =
      from(o in JobOffer,
        join: c in Continent,
        on: fragment("ST_Intersects(?,?)", o.office_point, c.polygon) == true,
        select: %{id: o.id, region: max(c.id)},
        where: is_nil(o.continent_id),
        group_by: o.id
      )
      |> Repo.all()

    if data == [] do
      :no_data
    else
      data
      |> Enum.each(fn %{id: id, region: region} ->
        %JobOffer{id: id}
        |> JobOffer.changeset_continent(%{continent_id: region})
        |> Repo.update!()
      end)

      :ok
    end
  end

  def get_destinations(latitude, longitude, radius_km) do
    radius_m = radius_km * 1000

    from(o in JobOffer,
      where:
        fragment(
          "ST_Intersects(?,ST_Buffer(ST_MakePoint(?, ?)::geography, ?))",
          o.office_point,
          ^longitude,
          ^latitude,
          ^radius_m
        ) == true
    )
    |> Repo.all()
  end
end
