defmodule Redis.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  @pool_size Application.get_env(:redis, :pool_size) || 1

  use Application

  def start(_type, _args) do
    redix_workers = for i <- 0..(@pool_size - 1) do
      args = [[host: redis_host(), port: redis_port()], [name: :"redix_#{i}"]]

      Supervisor.child_spec({Redix, args}, id: {Redix, i})
    end

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Redis.Worker.start_link(arg)
      # {Redis.Worker, arg},
    ]

    children = children ++ redix_workers

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Redis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp redis_host() do
    Application.get_env(:redis, :host) || "localhost"
  end

  defp redis_port() do
    redis_port = Application.get_env(:redis, :redis_port)
    cond do
      redis_port == nil ->
        6379
      :error = redis_port |> Integer.parse() ->
        6379
      {port, _rest} = redis_port |> Integer.parse() ->
        port
    end
  end
end
