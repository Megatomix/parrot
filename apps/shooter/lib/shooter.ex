defmodule Shooter do
  require Logger

  use Retry

  def shoot_msg(%{"app_id" => app_id} = payload) do
    Logger.debug "Shooting #{inspect payload}"
    send_to_integration(app_id, payload)
    send_to_aligator(payload)
  end
  def shoot_msg(_payload), do: nil

  defp send_to_integration(app_id, payload) do
    integration = Parrot.Customers.get_integration(app_id)
    if integration != nil do
      retry with: lin_backoff(10, 3) |> cap(1_000) |> Stream.take(4) do
        HTTPoison.post(
          integration.integration_endpoint,
          payload |> Poison.encode!,
          [
            {"content-type", "application/json"},
          ]
        )
      end
    else
      nil
    end
  end

  defp send_to_aligator(payload) do
    if aligator_url() != nil do
      HTTPoison.post(
        aligator_url() <> "/conversation",
        %{"event" => payload} |> Poison.encode!,
        [
          {"content-type", "application/json"},
        ]
      )
    else
      nil
    end
  end

  defp aligator_url() do
    Application.get_env(:shooter, Shooter, [])
    |> Keyword.get(:aligator_url)
  end
end
