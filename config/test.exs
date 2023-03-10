import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :conduit, Conduit.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "conduit_readstore_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :conduit, Conduit.EventStore,
  column_data_type: "jsonb",
  serializer: EventStore.JsonbSerializer,
  types: EventStore.PostgresTypes,
  database: "conduit_eventstore_test",
  schema: "public"

# Configure the event store database
# https://github.com/commanded/eventstore/blob/master/guides/Getting%20Started.md#using-the-jsonb-data-type
config :eventstore, EventStore.Storage,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "conduit_eventstore_test",
  hostname: "localhost",
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :conduit, ConduitWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "JMW+SXTo08TxfK5mK4IC3orNw/krgNYYPXsMusPZC8awSbQ3B9cMVYFD8ZXKLHvW",
  server: false

# In test we don't send emails.
config :conduit, Conduit.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :bcrypt_elixir, :log_rounds, 4
