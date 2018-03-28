use Mix.Config

config :parrot, ecto_repos: [Parrot.Repo]

import_config "#{Mix.env}.exs"
