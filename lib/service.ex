require Poison
require RedditApi
require RedditStream

defmodule SummonerAlertsService do
  use Application
  @sticky_title_contains "simple questions simple answers" 

  @moduledoc """
  Documentation for SummonerAlertsService.
  """

  def start() do
    IO.puts "starting"
    token = RedditApi.get_oauth_token

    get_qa_stickied_thread(token)
  end

  defp get_sticky_title(thread) do
    Map.get(thread, "data")
      |> Map.get("children")
      |> List.first
      |> Map.get("data")
      |> Map.get("title")
  end
  defp is_qa_thread(thread) do
    get_sticky_title(thread)
      |> String.downcase
      |> String.contains?(@sticky_title_contains)
  end

  def get_qa_stickied_thread(token, num \\ 1) do
    # TODO: Move "sticky monitoring" to a new process/agent/genserver (not sure)
    sub = 'summonerschool'
    thread = RedditApi.get_stickied_thread(token, sub, num)

    # TODO: Do something with the "thread" result (i.e. start processing it in another process)
    if is_qa_thread(thread), do: IO.puts("got QA thread"), else: get_qa_stickied_thread(token, 2)
  end

  def process do
    sub = 'learnprogramming/new'
    token = RedditApi.get_oauth_token

    RedditStream.fetch_new_threads_perpertually(token, sub)
      |> Stream.map(fn item -> item["data"]["id"] end)
      #|> Stream.map(fn id -> RedditApi.get_comments(token, sub, id) end)
      |> Stream.map(fn item -> IO.inspect item end)
      |> Stream.run
  end
end
