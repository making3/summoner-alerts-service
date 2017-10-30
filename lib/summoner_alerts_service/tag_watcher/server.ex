defmodule SAS.TagWatcher.Server do
  use GenServer

  # TODO: Change this to summonerschool. AskReddit has more data for testing.
  @subreddit "askreddit"

  # Client
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  # Server
  def init(state) do
    SAS.Subreddit.Supervisor.add_subreddit(@subreddit)

    fetch_group_tags() |> do_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # TODO: Only grab new groups or updates?
    fetch_group_tags() |> do_work()
    {:noreply, state}
  end

  defp fetch_group_tags() do
    groups = SAS.TagGroup |> SAS.Repo.all
    SAS.Repo.preload groups, :tags
  end

  defp do_work([]) do
    schedule_work()
  end
  defp do_work([head | tail]) do
    tags = Enum.map(head.tags, fn t -> t.name end)
    SAS.Tags.Server.add_grou_tags(@subreddit, head.name, tags)

    do_work(tail)
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 15 * 1000) # Every 15 seconds
    # Process.send_after(self(), :work, 5 * 60 * 1000) # Every 5 minutes
  end
end
