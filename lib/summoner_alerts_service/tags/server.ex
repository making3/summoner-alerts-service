defmodule SAS.Tags.Server do
  use GenServer

  # Client
  def start_link(subreddit) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(subreddit))
  end

  def add_user_tags(subreddit, user, tags) do
    GenServer.cast(via_tuple(subreddit), {:add, user, tags})
  end

  def get(subreddit) do
    GenServer.call(via_tuple(subreddit), :get)
  end

  defp via_tuple(subreddit) do
    {:via, :gproc, {:n, :l, {:subreddit_tag, subreddit}}}
  end

  # Server
  def init(_) do
    {:ok, %{}}
  end

  def handle_call(:get, _from, user_tags) do
    {:reply, user_tags, user_tags}
  end

  def handle_cast({:add, user, tags}, user_tags) do
    case Map.has_key?(user_tags, user) do
      true ->
        {:noreply, Map.replace(user_tags, user, tags)}
      _ ->
        {:noreply, Map.put(user_tags, user, tags)}
    end
  end
end
