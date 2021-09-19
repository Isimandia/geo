use Mix.Config

config :joffer,
  ecto_repos: [Joffer.Repo]

config :logger, level: :warning

import_config "#{Mix.env()}.exs"
