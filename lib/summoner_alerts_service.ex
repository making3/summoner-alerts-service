require Poison
require ExReddit
require ExRedditTagger

defmodule SummonerAlertsService do
  use Application

  @moduledoc """
  Documentation for SummonerAlerts.
  """

  def start(_, _) do
    IO.puts "starting"
    SummonerAlertsService.Supervisor.start_link(name: ServiceSupervisor)
  end

  # TODO: Move this to a worker.
  def process do
    {:ok, token} = ExReddit.OAuth.get_token()

    sub = "learnprogramming"
    tags = ["array", "list", "method", "scanf", "class", "api", "post"]
    return_only_matches = true # defaults to false

    ExRedditTagger.get_new_thread_tags(sub, token, tags, return_only_matches)
    |> Stream.map(&IO.inspect(&1))
    |> Stream.run()
  end
end
