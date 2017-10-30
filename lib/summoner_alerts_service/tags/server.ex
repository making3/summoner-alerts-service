defmodule SAS.Tags.Server do
  use GenServer

  # Client
  def start_link(subreddit) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(subreddit))
  end

  def add_group_tags(subreddit, group, tags) do
    GenServer.cast(via_tuple(subreddit), {:add, group, tags})
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

  def handle_call(:get, _from, group_tags) do
    {:reply, group_tags, group_tags}
  end

  def handle_cast({:add, group, tags}, group_tags) do
    case Map.has_key?(group_tags, group) do
      true ->
        {:noreply, Map.replace(group_tags, group, tags)}
      _ ->
        {:noreply, Map.put(group_tags, group, tags)}
    end
  end
end
