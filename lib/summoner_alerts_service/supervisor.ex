defmodule SAS.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(_) do
    children = [
      SAS.Tags.Supervisor,
      SAS.Subreddit.Supervisor,
      SAS.Repo,
      worker(SAS.TagWatcher.Server, [])
      # {SAS.StickyServer, name: StickyServer},
      # {SAS.StickyThreadFinderServer, name: StickyThreadFinderServer},
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
