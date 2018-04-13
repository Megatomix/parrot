defmodule Redis do
  @pool_size Application.get_env(:redis, :pool_size) || 1
  @prefix Application.get_env(:redis, :prefix, "")

  require Logger

  def command!(command) do
    Redix.command!(:"redix_#{random_index()}", command)
  end

  def save!(key, %{} = payload) do
    str_json = Poison.encode! payload
    Redis.command!(["SET", "#{redis_key(key)}", str_json])
  end
  def save!(_key, _payload) do
    raise ArgumentError, message: "Invalid argument, expected map"
  end

  def del!(key) do
    Redis.command!(["DEL", "#{redis_key(key)}"])
  end

  def get!(key) do
    result = Redis.command!(["GET", "#{redis_key(key)}"])
    case result do
      nil ->
        raise KeyError, key: key
      result ->
        result
        |> Poison.decode!
    end
  end

  def get(key, default \\ nil) do
    try do
      get!(key)
    rescue
      KeyError ->
        default
      Poison.SyntaxError ->
        default
    end
  end

  def update_session!(%{"user_id" => user_id, "app_id" => app_id} = payload) do
    key = "#{app_id}:#{user_id}"
    session = get(key, %{})

    messages = Map.get(session, "messages", [])
    messages = messages ++ [payload]

    new_session = Map.put(session, "messages", messages)
    save!(key, new_session)
  end

  defp random_index() do
    :rand.uniform(@pool_size) - 1
  end

  defp redis_key(key) do
    "#{@prefix}:#{key}"
  end
end
