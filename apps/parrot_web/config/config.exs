# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :parrot_web,
  namespace: ParrotWeb,
  ecto_repos: [Parrot.Repo]

# Configures the endpoint
config :parrot_web, ParrotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PhTzXMdFXT51X+cKrZdxPYgOn0FQak9+fThYwfBWIAvgTSFMeJWUug8Qv3L5t+/q",
  render_errors: [view: ParrotWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ParrotWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :parrot_web, :generators,
  context_app: :parrot

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
