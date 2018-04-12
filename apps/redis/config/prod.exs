use Mix.Config

config :redis,
  host: "${REDIS_HOST}",
  port: "${REDIS_PORT}",
  prefix: "parrot",
  pool_size: 5
