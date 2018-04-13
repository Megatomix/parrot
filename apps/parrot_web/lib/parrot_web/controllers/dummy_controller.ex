defmodule ParrotWeb.DummyController do
  use ParrotWeb, :controller

  def ok(conn, _params) do
    conn
    |> send_resp(200, "Ok")
  end

  def dump(conn, params) do
    ParrotWeb.Endpoint.broadcast("room:#{params["app_id"]}", "new_event", params)

    Task.async(fn ->
      handle_in(params)
    end)

    conn
    |> send_resp(200, "Ok")
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
