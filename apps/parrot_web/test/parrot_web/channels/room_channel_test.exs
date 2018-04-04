defmodule ParrotWeb.RoomChannelTest do
  use ParrotWeb.ChannelCase

  alias ParrotWeb.RoomChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{
        user_id: "test_user",
        app_id: "test_app",
        fallback: nil
      })
      |> subscribe_and_join(RoomChannel, "room:lobby")

    {:ok, socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "new_event with MSG payload should echo with RECV payload", %{socket: socket} do
    push socket, "new_event", %{"type" => "MSG", "hello" => "world!"}
    assert_broadcast "new_event", %{"type" => "RECV", "hello" => "world!"}
  end

  test "new_event doesn't arrive to different app_id", %{socket: socket} do
    broadcast_from! socket, "new_event", %{"app_id" => "wrong_app", "user_id" => "test_user"}

    refute_push "new_event", %{"app_id" => "wrong_app", "user_id" => "test_user"}
  end

  test "new_event doesn't arrive to same app_id and different user_id", %{socket: socket} do
    broadcast_from! socket, "new_event", %{"app_id" => "test_app", "user_id" => "test_user_2"}

    refute_push "new_event", %{"app_id" => "test_app", "user_id" => "test_user_2"}
  end

  test "new_event arrive to same app_id and user_id", %{socket: socket} do
    broadcast_from! socket, "new_event", %{"app_id" => "test_app", "user_id" => "test_user"}

    assert_push "new_event", %{"app_id" => "test_app", "user_id" => "test_user"}
  end
end
