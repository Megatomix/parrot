defmodule ParrotWeb.DummyController do
  use ParrotWeb, :controller

  def ok(conn, params) do
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
  end
  defp handle_in(payload) do
    Shooter.shoot_msg(payload)
  end
end
