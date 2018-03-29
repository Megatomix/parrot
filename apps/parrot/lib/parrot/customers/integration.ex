defmodule Parrot.Customers.Integration do
  use Ecto.Schema
  import Ecto.Changeset
  alias Parrot.Customers.Integration


  schema "integrations" do
    field :app_id, :string
    field :app_secret, :string
    field :integration_endpoint, :string
  end

  @doc false
  def changeset(%Integration{} = integration, attrs) do
    integration
    |> cast(attrs, [:app_id, :app_secret, :integration_endpoint])
    |> validate_required([:app_id, :app_secret, :integration_endpoint])
  end
end
