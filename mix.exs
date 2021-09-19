defmodule Joffer.MixProject do
  use Mix.Project

  def project do
    [
      app: :joffer,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Joffer.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:geo_postgis, "~> 3.4"},
      {:ecto_sql, "~> 3.4"},
      {:csv, "~> 2.4.1"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds/upload_regions.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      run_script: ["run --no-halt lib/start.exs"]
    ]
  end
end
