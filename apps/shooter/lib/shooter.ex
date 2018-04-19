defmodule Shooter do
  require Logger

  use Retry

  def shoot_msg(%{"app_id" => app_id} = payload) do
    Logger.debug "Shooting #{inspect payload}"
    send_to_integration(app_id, payload)
    send_to_aligator(payload)
  end
  def shoot_msg(_payload), do: nil

  def send_to_aligator(payload) do
    Logger.debug "Sending to aligator #{inspect payload}"
    if aligator_url() != nil do
      retry_send(aligator_url() <> "/conversation", %{"event" => payload})
    else
      nil
    end
  end

  defp send_to_integration(app_id, payload) do
    integration = Parrot.Customers.get_integration(app_id)
    if integration != nil do
      req = [{integration.primary_app, payload}, {integration.secondary_app, %{"standby" => payload}}]
      tasks = Enum.reduce(0..(length(req)), [], fn {url, body}, acc ->
        [Task.async(fn -> retry_send(url, body) end) | acc]
      end)

      Enum.map(tasks, &Task.await/1)
    else
      nil
    end
  end

  defp retry_send(nil, _payload), do: nil
  defp retry_send("", _payload), do: nil
  defp retry_send(url, payload) do
    retry with: lin_backoff(10, 3) |> cap(1_000) |> Stream.take(4) do
      HTTPoison.post(
        url,
        payload |> Poison.encode!,
        [
          {"content-type", "application/json"},
        ]
      )
    end
  end

  defp aligator_url() do
    Application.get_env(:shooter, Shooter, [])
    |> Keyword.get(:aligator_url)
  end
end
