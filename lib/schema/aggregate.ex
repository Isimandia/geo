defmodule Joffer.Schema.Aggregate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "aggregates" do
    belongs_to(:continent, Joffer.Schema.Continent)
    belongs_to(:job_category, Joffer.Schema.JobCategory)
    field(:amount, :integer)
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:continent_id, :job_category_id, :amount])
    |> validate_required([:job_category_id, :amount])
    |> validate_number(:amount, greater_than: 0)
  end
end
