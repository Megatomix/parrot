use Mix.Config

config :shooter, Shooter,
  aligator_url: "http://aligator-service.${NAMESPACE}.svc.cluster.local:4000/aligator"
