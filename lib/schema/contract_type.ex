defmodule Joffer.Schema.ContractType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contract_types" do
    field(:name, :string)
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
