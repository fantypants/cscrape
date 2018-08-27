use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cryptscrape, Cryptscrape.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :cryptscrape, Cryptscrape.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "cryptscrape_test",
  hostname: "localhost",
  timeout: 60_000,
 pool_timeout: 60_000,
  pool: Ecto.Adapters.SQL.Sandbox


# Comeonin password hashing test config
#config :argon2_elixir,
  #t_cost: 2,
  #m_cost: 8
config :bcrypt_elixir, log_rounds: 4
#config :pbkdf2_elixir, rounds: 1
