require RedditApi

defmodule RedditApiTest do
  use ExUnit.Case
  doctest RedditApi

  test "get_one_thread" do
    token = RedditApi.get_oauth_token
    threads = RedditApi.fetch_new_threads_perpertually(token, 'learnprogramming')
      |> Stream.take(1)
      |> Enum.to_list
    IO.inspect(threads)
  end
end
