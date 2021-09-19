defmodule Joffer.Schema.JobCategory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job_categories" do
    field(:name, :string)
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
