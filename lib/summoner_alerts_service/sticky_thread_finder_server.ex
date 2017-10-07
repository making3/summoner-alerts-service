require ExReddit
require SummonerAlertsService.Helpers.Thread

defmodule SummonerAlertsService.StickyThreadFinderServer do
  use GenServer

  ## Client
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  ## Server
  def init(:ok) do
    schedule_work()
    {:ok, ""}
  end

  def handle_info(:work, state) do
    # TODO: Find the newest summoner school thread.
    # TODO: Save this to a database table (Thread: { threadId, title })
    token = ExReddit.OAuth.get_token!()
    get_stickied_thread token
    {:noreply, state}
  end

  def schedule_work() do
    Process.send_after(self(), :work, 2000) #2 * 60 * 1000) # 2 minutes
  end

  def get_stickied_thread(token, num \\ 1) do
    sub = "summonerschool"
    # thread = RedditApi.get_stickied_thread(token, sub, num)
    #   |> Thread.parse
    #
    # if Thread.is_qa(thread) do
    #   thread_id = Thread.id(thread)
    #   StickyServer.update(StickyServer, thread_id)
    # else
    #   if num == 1 do
    #     get_stickied_thread(token, 2)
    #   end
    # end

    schedule_work();
  end
end
