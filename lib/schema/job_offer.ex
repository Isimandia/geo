defmodule Joffer.Schema.JobOffer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job_offers" do
    field(:name, :string)
    belongs_to(:contract_type, Joffer.Schema.ContractType)
    belongs_to(:profession, Joffer.Schema.Profession)
    field(:office_point, Geo.PostGIS.Geometry)
    belongs_to(:continent, Joffer.Schema.Continent)
    has_one(:job_category, through: [:profession, :job_category])
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:name, :contract_type_id, :profession_id, :office_point, :continent_id])
    |> validate_required([:name, :contract_type_id, :profession_id, :office_point])
  end

  def changeset_continent(cart, attrs) do
    cart
    |> cast(attrs, [:continent_id])
    |> validate_required([:continent_id])
  end
end
