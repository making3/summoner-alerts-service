defmodule SAS.Subreddit.Server do
  use GenServer

  # Client implementation
  def start_link(subreddit) do
    SAS.Tags.Supervisor.add_subreddit(subreddit)

    GenServer.start_link(__MODULE__, subreddit, name: via_tuple(subreddit))
  end

  defp via_tuple(subreddit) do
    {:via, :gproc, {:n, :l, {:subreddit, subreddit}}}
  end

  # Server implementation
  def init(subreddit) do
    IO.puts "starting r/#{subreddit} tag stream"

    pid = start_stream(subreddit)
    {:ok, {subreddit, pid}}
  end

  defp start_stream(subreddit) do
    spawn_link fn ->
      {:ok, token} = ExReddit.OAuth.get_token()

      ExRedditTagger.Stream.fetch_new_threads_perpertually(token, subreddit)
      |> Stream.map(&(Map.get(&1, "data")))
      |> Stream.map(&(parse_thread(&1, subreddit)))
      |> Stream.filter(&should_return_match(&1))
      |> Stream.map(&IO.inspect(&1)) # TODO: Tie results to users of course
      |> Stream.run()
    end
  end

  defp parse_thread(thread, subreddit) do
    tags = subreddit
    |> SAS.Tags.Server.get()
    |> get_unique_tags()
    IO.inspect(Map.get(thread, "title"))

    found_tags = parse_tags(thread, tags)
    {Map.get(thread, "id"), found_tags}
  end

  defp parse_tags(thread, tags) do
    body_result = get_tags_from_map(thread, "selftext", tags)
    get_tags_from_map(thread, "title", tags)
    |> Enum.concat(body_result)
  end

  defp get_tags_from_map(thread, property, tags) do
    text = thread
    |> Map.get(property)
    |> String.downcase

    Enum.filter(tags, fn tag -> String.contains?(text, tag) end)
  end

  defp should_return_match({_, []}), do: false
  defp should_return_match({_, _}), do: true

  defp get_unique_tags(user_tags) do
    user_tags
    |> Map.values
    |> List.flatten
    |> Enum.uniq
  end
end
