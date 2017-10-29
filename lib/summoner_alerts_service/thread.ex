defmodule SAS.Thread do
  use Ecto.Schema

  schema "threads" do
    field :thread_id
    field :title
  end
end
