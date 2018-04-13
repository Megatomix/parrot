defmodule ParrotWeb.RoomTracker do
  @behaviour Phoenix.Tracker

  @task_supervisor Module.concat(__MODULE__, TaskSupervisor)

  require Logger

  def start_link(opts) do
    import Supervisor.Spec
    opts = Keyword.merge([name: __MODULE__], opts)

    children = [
      supervisor(Task.Supervisor, [[name: @task_supervisor]]),
      worker(Phoenix.Tracker, [__MODULE__, opts, opts])
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
end

  def init(opts) do
    server = Keyword.fetch!(opts, :pubsub_server)
    {:ok, %{pubsub_server: server, node_name: Phoenix.PubSub.node_name(server)}}
  end

  def handle_diff(diff, state) do
    Task.Supervisor.start_child(@task_supervisor, fn ->
      for {"admin:" <> app_id = topic, {_joins, leaves}} <- diff do
        for {user_id, _meta} <- leaves do
          not is_online?(topic, user_id)
            && Redis.del!("#{app_id}:#{user_id}")
            && Shooter.shoot_msg(%{
              "app_id" => app_id,
              "user_id" => user_id,
              "type" => "END_SESSION"
            })
        end
      end
    end)

    {:ok, state}
  end

  def track(%Phoenix.Socket{} = socket, key, meta) do
    track(socket.channel_pid, socket.topic, key, meta)
  end
  def track(pid, topic, key, meta) do
    Phoenix.Tracker.track(__MODULE__, pid, topic, key, meta)
  end

  def list(%Phoenix.Socket{topic: topic}), do: list(topic)
  def list(topic) do
    Phoenix.Presence.list(__MODULE__, topic)
  end

  def fetch(_topic, presences), do: presences

  def is_online?(topic, key), do: list(topic) |> Map.has_key?(key)
end
