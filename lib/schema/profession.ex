defmodule Joffer.Schema.Profession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "professions" do
    field(:name, :string)
    field(:external_id, :string)
    belongs_to(:job_category, Joffer.Schema.JobCategory)
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:name, :external_id, :job_category_id])
    |> cast_assoc(:job_category)
    |> validate_required([:name, :external_id, :job_category_id])
  end
end
