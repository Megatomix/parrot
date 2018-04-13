defmodule ParrotWeb.DummyController do
  use ParrotWeb, :controller

  def ok(conn, _params) do
    conn
    |> send_resp(200, "Ok")
  end

  def dump(conn, %{"app_id" => app_id, "user_id" => user_id} = params) do
    if ParrotWeb.RoomTracker.is_online?("admin:#{app_id}", user_id) do
      ParrotWeb.Endpoint.broadcast("#{app_id}:#{user_id}", "new_event", params)

      Task.async(fn ->
        handle_in(params)
      end)

      conn
      |> send_resp(200, "Ok")
    else
      conn
      |> send_resp(404, "User not online anymore")
    end
  end
  def dump(conn, _params) do
    conn
    |> send_resp(400, "Missing app_id or user_id")
  end

  defp handle_in(%{"type" => "RECV"} = payload) do
    echo = Map.put(payload, "type", "ECHO")

    Shooter.shoot_msg(echo)
    Shooter.send_to_aligator(payload)
    Redis.update_session!(payload)
  end
  defp handle_in(payload) do
    Shooter.send_to_aligator(payload)
  end
end
