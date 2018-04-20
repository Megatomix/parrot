defmodule ParrotWeb.RoomChannel do
  use ParrotWeb, :channel
  alias ParrotWeb.RoomTracker, as: Tracker

  require Logger

  intercept ["new_event"]

  def join("room:" <> app_id, _payload, %{assigns: %{user_id: user_id}} = socket) do
    if authorized?(app_id) do
      send self(), :after_join
      ParrotWeb.Endpoint.subscribe("#{app_id}:#{user_id}")
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_event", %{"type" => "ECHO"}, socket) do
    {:noreply, socket}
  end
  def handle_in("new_event", payload, socket) do
    broadcast_msg(payload, socket)

    Shooter.shoot_msg(payload)
    {:noreply, socket}
  end

  def handle_out("new_event",
                 %{"app_id" => app_id,
                   "user_id" => user_id
                 } = payload,
                 %{assigns: %{app_id: app_id, user_id: user_id}} = socket) do
    push(socket, "new_event", payload)
    {:noreply, socket}
  end
  def handle_out("new_event", _payload, socket) do
    {:noreply, socket}
  end

  def handle_info(:after_join, %{
    assigns: %{app_id: app_id, user_id: user_id, fallback: fallback}
  } = socket) do
    Shooter.shoot_msg(%{
      "app_id" => app_id,
      "user_id" => user_id,
      "type" => "CONNECT",
      "payload" => %{
        "fallback" => fallback
      }
    })

    if Tracker.is_online?("admin:#{app_id}", user_id) do
      messages =
        Redis.get("#{app_id}:#{user_id}", %{})
        |> Map.get("messages", [])

      for message <- messages do
        push(socket, "new_event", message)
      end
      Logger.debug "#{user_id} already online"
    end

    {:ok, _} = Tracker.track(self(), "admin:#{app_id}", user_id, %{})
    Logger.debug("handle_info #{inspect(Tracker.list("admin:#{app_id}"))}")
    {:noreply, socket}
  end

  alias Phoenix.Socket.Broadcast
  def handle_info(%Broadcast{topic: _, event: ev, payload: payload}, socket) do
    push socket, ev, payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(app_id) do
    case Parrot.Customers.get_customer(app_id) do
      %{active: active} ->
        active
      _ ->
        false
    end
  end

  defp broadcast_msg(%{"type" => "MSG"} = payload, socket) do
    new_payload = Map.put(payload, "type", "RECV")

    Redis.update_session!(new_payload)

    broadcast_from(socket, "new_event", new_payload)
  end
  defp broadcast_msg(_payload, _socket), do: nil
end
