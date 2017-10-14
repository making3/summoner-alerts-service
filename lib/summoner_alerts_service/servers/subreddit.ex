defmodule SummonerAlertsService.Servers.Subreddit do
  use GenServer

  ## Client implementation
  def start_link(subreddit) do
    # TODO: How to get options and pass them to start_link (i.e. name it)
    GenServer.start_link(__MODULE__, subreddit)
  end

  def add_tags(server, user, tags) do
    GenServer.cast(server, {:add_tags, {user, tags}})
  end

  ## Server implementation
  def init(subreddit) do
    IO.puts "starting r/#{subreddit} tag stream"

    # TODO: Get tags from database
    user_tags = %{"yeamanz" => ["why", "what"]}
    pid = start_stream(subreddit, user_tags)
    state = {subreddit, pid, user_tags}
    {:ok, state}
  end

  def handle_cast({:add_tags, user, tags}, {subreddit, user_tags}) do
    new_user_tags = Map.put(user_tags, user, tags)
    {:noreply, {subreddit, new_user_tags}}
  end

  def start_stream(subreddit, user_tags) do
    spawn_link fn ->
      {:ok, token} = ExReddit.OAuth.get_token()
      ExRedditTagger.get_new_thread_tags(
        subreddit,
        token,
        Map.get(user_tags, "yeamanz"), # TODO: Compile list
        true)
      |> Stream.map(&IO.inspect(&1)) # TODO: Tie results to users of course
      |> Stream.run()
    end
  end
end
