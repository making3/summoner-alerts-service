require Poison
require RedditApi
require RedditStream
require ServiceSupervisor

defmodule SummonerAlertsService do
  use Application

  @moduledoc """
  Documentation for SummonerAlertsService.
  """

  def start() do
    IO.puts "starting"

    ServiceSupervisor.start_link([])
    :timer.sleep(1000)
    :timer.sleep(10000)
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
