require ExReddit

defmodule SAS.StickyServer do
  use GenServer
  @summonerschool "summonerschool"

  ## Client implementation
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def update(server, thread_id) do
    GenServer.cast(server, {:update, thread_id})
  end

  ## Server implementation
  def init(:ok) do
    schedule_work()
    IO.puts "starting sticky server"

    # TODO: Get state from db on load
    # TODO: Get/Store oauth token here. Let server crash after token expires maybe?
    {:ok, ""}
  end

  def handle_info(:work, "") do
    schedule_work()
    {:noreply, ""}
  end

  def handle_info(:work, thread_id) do
    token = ExReddit.OAuth.get_token!()
    comments = ExReddit.Api.Subreddit.get_comments(token, @summonerschool, thread_id)

    # TODO: Parse comments in thread
    IO.inspect(comments)

    schedule_work()
    {:noreply, thread_id}
  end

  def handle_cast({:update, thread_id}, _) do
    {:noreply, thread_id}
  end

  def schedule_work() do
    Process.send_after(self(), :work, 500) #2 * 60 * 1000) # 2 minutes
  end
end
