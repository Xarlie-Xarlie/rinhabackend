# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :rinhabackend,
  ecto_repos: [Rinhabackend.Repo]

# Configures the endpoint
config :rinhabackend, RinhabackendWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: RinhabackendWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Rinhabackend.PubSub,
  live_view: [signing_salt: "vjJtLRPH"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
