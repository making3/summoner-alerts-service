defmodule SAS.Subreddit.Server do
  use GenServer

  # Client implementation
  def start_link({subreddit, user, tags}) do
    SAS.Tags.Supervisor.add(subreddit)
    SAS.Tags.Server.add(subreddit, user, tags)

    GenServer.start_link(__MODULE__, subreddit, name: via_tuple(subreddit))
  end

  def add_tags(subreddit, user, tags) do
    SAS.Tags.Server.add(subreddit, user, tags)
    GenServer.call(via_tuple(subreddit), {:kill})
  end

  defp via_tuple(subreddit) do
    {:via, :gproc, {:n, :l, {:subreddit, subreddit}}}
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
