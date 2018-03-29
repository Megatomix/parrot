defmodule Shooter do
  require Logger

  def shoot_msg(%{"app_id" => app_id} = payload) do
    Logger.debug "Shooting #{inspect payload}"
    integration = Parrot.Customers.get_integration(app_id)
    HTTPoison.post(
      integration.integration_endpoint,
      payload |> Poison.encode!,
      [
        {"Content-Type", "application/json"},
      ]
    )
  end
  def shoot_msg(_payload), do: nil
end
