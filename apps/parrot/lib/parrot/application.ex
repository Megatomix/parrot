defmodule Parrot.Application do
  @moduledoc """
  The Parrot Application Service.

  The parrot system business domain lives in this application.

  Exposes API to clients such as the `ParrotWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Parrot.Repo, []),
    ], strategy: :one_for_one, name: Parrot.Supervisor)
  end
end
