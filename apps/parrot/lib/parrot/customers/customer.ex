defmodule Parrot.Customers.Customer do
  use Ecto.Schema

  schema "customers" do
    field :name, :string
    field :app_id, :string
    field :active, :boolean

    timestamps()
  end
end
