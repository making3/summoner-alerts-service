require Poison
require RedditApi
require RedditStream
require ServiceSupervisor

defmodule SummonerAlerts do
  use Application

  @moduledoc """
  Documentation for SummonerAlerts.
  """

  def start(_, _) do
    IO.puts "starting"

    ServiceSupervisor.start_link(name: ServiceSupervisor)
    # TODO: Application exits when running "mix run". Not sure how to resolve (newbie things)
  end

  # TODO: Move this out
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
