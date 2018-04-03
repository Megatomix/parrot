defmodule ParrotWeb.Router do
  use ParrotWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ParrotWeb do
    pipe_through :api

    post "/", DummyController, :dump
  end

  scope "/", ParrotWeb do
    get "/phoenix", DummyController, :ok
  end
end
