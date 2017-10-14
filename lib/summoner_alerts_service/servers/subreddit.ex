defmodule SummonerAlertsService.Servers.Subreddit do
  use GenServer

  # Client implementation
  def start_link({subreddit, users, tags}) do
    # TODO: How to get options and pass them to start_link (i.e. name it)
    server = get_subreddit_atom(subreddit)
    SAS.Tags.Server.add(subreddit, users, tags)
    GenServer.start_link(__MODULE__, subreddit, name: server)
  end

  def add_tags(subreddit, user, tags) do
    server = get_subreddit_atom(subreddit)
    SAS.Tags.Server.add(subreddit, user, tags)
    GenServer.call(server, {:kill})
  end

  defp get_subreddit_atom(subreddit) do
    :"#{subreddit}"
  end

  # Server implementation
  def init(subreddit) do
    IO.puts "starting r/#{subreddit} tag stream"

    user_tags = SAS.Tags.Server.get(subreddit)
    pid = start_stream(subreddit, user_tags)
    {:ok, {subreddit, pid}}
  end

  def handle_info(:kill, {subreddit, pid}) do
    Process.exit(pid, :kill)
    {:stop, :normal, {subreddit, pid}}
  end

  defp start_stream(subreddit, user_tags) do
    tags = get_tags(user_tags)

    spawn_link fn ->
      {:ok, token} = ExReddit.OAuth.get_token()
      ExRedditTagger.get_new_thread_tags(
        subreddit,
        token,
        tags,
        true)
      |> Stream.map(&IO.inspect(&1)) # TODO: Tie results to users of course
      |> Stream.run()
    end
  end

  defp get_tags(user_tags) do
    user_tags
    |> Map.values
    |> List.flatten
    |> Enum.uniq
  end
end
