# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :autheer,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :autheer, AutheerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: AutheerWeb.ErrorHTML, json: AutheerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Autheer.PubSub,
  live_view: [signing_salt: "e8IRJIMu"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  autheer: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :autheer, :session,
  store: :cookie,
  key: "autheer",
  signing_salt: "60/WIHg2",
  same_site: "Lax",
  domain: "lvh.me"

config :autheer, :host, "https://auth.lvh.me"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
