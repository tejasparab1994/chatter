use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :chatter, Chatter.Endpoint,
  secret_key_base: "GN9cxKjT1+s7SOKHMUB+qXTCNadAkKt7Zy50Ach8fly21qSzRPWv15YcRy2NydOX"

# Configure your database
config :chatter, Chatter.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "chatter_prod",
  pool_size: 15
