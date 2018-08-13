# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :cryptscrape,
  ecto_repos: [Cryptscrape.Repo]

# Configures the endpoint
config :cryptscrape, Cryptscrape.Endpoint,
  url: [host: "localhost"],
  secretkey: "bdacf43b588c293b7671",
  accesskey: "56c097939b830be846c4e84b2",
  user: "matthewmjeaton@gmail.com",
  pass: "Eato0810a!",
  stripe_key: "sk_test_6fOeP3lRCNZo9DGlIMR1MNfx",
  webhook_key: "whsec_NAiJs7xbLG3TjnFS7RBtjKEvhpzybm4m",
  git: "02a08184f71e82e43675fae4c33d26fbfe023fe1",
  secret_key_base: "fK6jdaBVymPrORz34ylV9RGonNrtjCjfyC8KCsU4QCpQ3wm1BffbCbz8xzZHfQ4M",
  render_errors: [view: Cryptscrape.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cryptscrape.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Phauxth authentication configuration
config :phauxth,
  token_salt: "iRbASyEJ",
  endpoint: Cryptscrape.Endpoint

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :stripity_stripe, api_key: "sk_test_0gvWZW6A0mDk1WZFhacn5It3"

config :cryptscrape, Cryptscrape.Mailer,
  adapter: Bamboo.LocalAdapter



# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
