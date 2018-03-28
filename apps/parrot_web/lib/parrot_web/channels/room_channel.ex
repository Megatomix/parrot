defmodule ParrotWeb.RoomChannel do
  use ParrotWeb, :channel
  intercept ["new_event"]

  def join("room:" <> _userId, payload, socket) do
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

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("new_event", %{"type" => "MSG"} = payload, socket) do
    new_payload = Map.put(payload, "type", "RECV")
    broadcast socket, "new_event", new_payload
    {:noreply, socket}
  end

  def handle_in("new_event", _payload, socket) do
    {:noreply, socket}
  end

  def handle_out("new_event", %{"app_id" => app_id} = payload, %{assigns: %{app_id: app_id}} = socket) do
    require Logger
    Logger.debug inspect(payload)
    Logger.debug inspect(socket.assigns)
    push socket, "new_event", payload
    {:noreply, socket}
  end

  def handle_out("new_event", payload, socket) do
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
