defmodule ParrotWeb.Router do
  use ParrotWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ParrotWeb do
    pipe_through :api
  end
end
