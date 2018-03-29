defmodule Shooter do
  require Logger

  def shoot_msg(%{"app_id" => app_id} = payload) do
    Logger.debug "Shooting #{inspect payload}"
    send_to_integration(app_id, payload)
    send_to_aligator(payload)
  end
  def shoot_msg(_payload), do: nil

  defp send_to_integration(app_id, payload) do
    integration = Parrot.Customers.get_integration(app_id)
    if integration != nil do
      HTTPoison.post(
        integration.integration_endpoint,
        payload |> Poison.encode!,
        [
          {"Content-Type", "application/json"},
        ]
      )
    else
      nil
    end
  end

  defp send_to_aligator(payload) do
    if aligator_url() != "" do
      HTTPoison.post(
        aligator_url() <> "/conversation",
        %{"event" => payload} |> Poison.encode!,
        [
          {"Content-Type", "application/json"},
        ]
      )
    else
      nil
    end
  end

  defp aligator_url() do
    Application.get_env(:shooter, Aligator, [])
    |> Keyword.get(:aligator_url, "")
  end
end
