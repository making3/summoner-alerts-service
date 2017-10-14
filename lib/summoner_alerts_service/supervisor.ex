defmodule SummonerAlertsService.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      # {SummonerAlertsService.StickyServer, name: StickyServer},
      # {SummonerAlertsService.StickyThreadFinderServer, name: StickyThreadFinderServer},

      # TODO: Find out how to update this supervisor (since it's a string, you can't name it)
      {SummonerAlertsService.Servers.Subreddit, 'learnprogramming'}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
