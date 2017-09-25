defmodule SummonerAlerts.Thread do
  use Ecto.Schema

  schema "thread" do
    field :thread_id
    field :title
  end
end
