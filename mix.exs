defmodule SAS.Mixfile do
  use Mix.Project

  def project do
    [
      app: :summoner_alerts_service,
      version: "0.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {SAS, []},
      applications: [:httpotion, :ecto, :postgrex, :exreddit, :gproc],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpotion, "~> 3.0.2"},
      {:poison, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:exreddit_tagger, git: "https://github.com/making3/exreddit_tagger.git", branch: "master"},
      {:gproc, "0.3.1"}
    ]
  end
end
