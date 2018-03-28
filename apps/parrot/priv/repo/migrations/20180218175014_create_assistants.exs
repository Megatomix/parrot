defmodule Parrot.Repo.Migrations.CreateAssistants do
  use Ecto.Migration

  def change do
    create table(:assistants) do
      add :app_id, :string
      add :app_secret, :string
      add :webhook, :string

      timestamps()
    end

  end
end
