defmodule SASTest do
  use ExUnit.Case
  doctest SAS

  test "noworky" do
      subreddit = "askreddit"
      {:ok, token} = ExReddit.OAuth.get_token()

      ExRedditTagger.Stream.fetch_new_threads_perpertually(token, subreddit)
      |> Stream.map(&IO.inspect(&1)) # TODO: Tie results to users of course
      # |> Stream.map(&(Map.get(&1, "data")))
      # |> Stream.map(&(parse_thread(&1, subreddit)))
      # |> Stream.filter(&should_return_match(&1))
      |> Stream.run()
  end
end
