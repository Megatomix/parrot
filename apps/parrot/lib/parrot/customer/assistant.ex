defmodule Parrot.Customer.Assistant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Parrot.Customer.Assistant


  schema "assistants" do
    field :app_id, :string
    field :app_secret, :string
    field :webhook, :string

    timestamps()
  end

  @doc false
  def changeset(%Assistant{} = assistant, attrs) do
    assistant
    |> cast(attrs, [:app_id, :app_secret, :webhook])
    |> validate_required([:app_id, :app_secret, :webhook])
  end
end
