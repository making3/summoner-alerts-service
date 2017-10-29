require Poison
require ExReddit
require ExRedditTagger

defmodule SAS do
  use Application

  @moduledoc """
  Documentation for SummonerAlerts.
  """

  def start(_, _) do
    IO.puts "starting"
    SAS.Supervisor.start_link(name: ServiceSupervisor)

    subreddit = "askreddit"
    SAS.Subreddit.Supervisor.add_subreddit(subreddit)

    SAS.Tags.Server.add_user_tags(subreddit, "matt", ["who"])

    :timer.sleep(120000)

    IO.puts("adding more tags")
    SAS.Tags.Server.add_user_tags(subreddit, "matt", ["why", "what", "who"])

    :timer.sleep(1000000)
  end
end
