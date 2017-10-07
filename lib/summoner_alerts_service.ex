require Poison
# require ServiceSupervisor
require ExReddit
require ExRedditTagger

defmodule SummonerAlertsService do
  use Application

  @moduledoc """
  Documentation for SummonerAlerts.
  """

  def start(_, _) do
    # import Supervisor.Spec
    # IO.puts "starting"
    # #ServiceSupervisor.start_link(name: ServiceSupervisor)
    #
    # children = [
    #   SummonerAlerts.Repo
    # ]
    # opts = [strategy: :one_for_one, name: SummonerAlerts.Supervisor]
    # Supervisor.start_link(children, opts)
    # TODO: Application exits when running "mix run". Not sure how to resolve (newbie things)
  end

  # TODO: Move this out
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
