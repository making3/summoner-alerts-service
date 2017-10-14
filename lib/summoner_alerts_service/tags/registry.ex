defmodule SAS.Tags.Registry do
  use GenServer

  # Client
  def start_link do
    GenServer.start_link(__MODULE__, nil, name: :tags_registry)
  end

  def whereis_name(subreddit) do
    GenServer.call(:tags_registry, {:whereis_name, subreddit})
  end

  def register_name(subreddit, pid) do
    GenServer.call(:tags_registry, {:register_name, subreddit, pid})
  end

  def unregister_name(subreddit) do
    GenServer.cast(:tags_registry, {:unregister_name, subreddit})
  end

  def send(subreddit, message) do
    case whereis_name(subreddit) do
      :undefined ->
        {:badarg, {subreddit, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  # Server
  def init(_) do
    {:ok, Map.new}
  end

  def handle_call({:whereis_name, subreddit}, _from, state) do
    {:reply, Map.get(state, subreddit, :undefined), state}
  end

  def handle_call({:register_name, subreddit, pid}, _from, state) do
    case Map.get(state, subreddit) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(state, subreddit, pid)}
      _ ->
        {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_name, subreddit}, state) do
    {:noreply, Map.delete(state, subreddit)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    {:noreply, remove_pid(state, pid)}
  end

  def remove_pid(state, pid_to_remove) do
    remove = fn {_key, pid} -> pid != pid_to_remove end
    Enum.filter(state, remove) |> Enum.into(%{})
  end
end
