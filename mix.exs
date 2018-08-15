defmodule Cryptscrape.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cryptscrape,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Cryptscrape, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0-rc"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:phauxth, "~> 1.2"},
      {:bcrypt_elixir, "~> 1.0"},
      {:cowboy, "~> 1.0"},
      {:httpotion, "~> 3.1.0"},
      {:poison, "~> 3.1.0", override: true},
      {:friendly, "~> 1.0.0"},
      {:httpoison, "~> 1.0"},
      {:argon2_elixir, "~> 1.2"},
      {:bamboo, "~> 1.0"},
      {:stripity_stripe, "~> 2.0"},
      {:csvlixir, "~> 2.0.3"},
      {:csv, "~> 1.4.0"},
      {:ex_machina, "~> 2.2"},
      {:bamboo_smtp, "~> 1.5.0"},
      {:edeliver, "~> 1.4.2"},
      {:distillery, "~> 1.4"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
