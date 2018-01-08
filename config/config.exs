# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :polytext,
  ecto_repos: [Polytext.Repo]

# Configures the endpoint
config :polytext, PolytextWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t48rGELcgydWPSIrprivhXwjQp94vD1jR7T6AS/RsjJ+W488gJ9A1W0EAjuTyO95",
  render_errors: [view: PolytextWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Polytext.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  s3_bucket_name: System.get_env("S3_BUCKET_NAME")


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
