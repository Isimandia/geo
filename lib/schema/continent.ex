defmodule Joffer.Schema.Continent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "continents" do
    field(:name, :string)
    field(:polygon, Geo.PostGIS.Geometry)
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:name, :polygon])
    |> validate_required([:name, :polygon])
  end
end
