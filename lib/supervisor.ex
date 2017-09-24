require StickyServer
require StickyThreadFinderServer

defmodule ServiceSupervisor do
  use Supervisor
  
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      { StickyServer, name: StickyServer },
      { StickyThreadFinderServer, name: StickyThreadFinderServer }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
