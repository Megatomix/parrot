defmodule ParrotWeb.Dummy do
  use ParrotWeb, :controller

  def dump(conn, params) do
    ParrotWeb.Endpoint.broadcast("room:#{params["app_id"]}", "new_event", params)

    Task.async(fn ->
      echo_back(params)
    end)

    conn
    |> send_resp(200, "Ok")
  end

  defp echo_back(%{"type" => "RECV"} = payload) do
    echo = Map.put(payload, "type", "ECHO")

    Shooter.shoot_msg(echo)
  end
  defp echo_back(_payload), do: nil
end
