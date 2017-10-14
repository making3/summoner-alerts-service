defmodule SAS.Tags.Supervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: :subreddit_supervisor)
  end

  def add(subreddit) do
    Supervisor.start_child(
      :subreddit_supervisor,
      [subreddit]
    )
  end

  def init(_) do
    children = [
      worker(SAS.Tags.Server, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
