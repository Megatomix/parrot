defmodule ParrotWeb.RoomChannel do
  use ParrotWeb, :channel

  require Logger

  intercept ["new_event"]

  def join("room:" <> _appId, payload, socket) do
    if authorized?(payload) do
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

  # Add authorization logic here as required.
  defp authorized?(payload) do
    true
  end

  defp broadcast_msg(%{"type" => "MSG"} = payload, socket) do
    new_payload = Map.put(payload, "type", "RECV")

    broadcast_from(socket, "new_event", new_payload)
  end
  defp broadcast_msg(_payload, _socket), do: nil
end
