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

  def application do
    [
      mod: {SummonerAlertsService, []},
      applications: [:httpotion],
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpotion, "~> 3.0.2"},
      {:poison, "~> 3.1"}
    ]
  end
end
