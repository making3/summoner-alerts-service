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
  end
end
