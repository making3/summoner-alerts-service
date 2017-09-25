defmodule SummonerAlertsService.Mixfile do
  use Mix.Project

  def project do
    [
      app: :service,
      version: "0.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {SummonerAlertsService, []},
      applications: [:httpotion],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpotion, "~> 3.0.2"},
      {:poison, "~> 3.1"}
    ]
  end
end
