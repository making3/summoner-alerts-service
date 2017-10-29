defmodule SAS.Thread do
  use Ecto.Schema

  schema "threads" do
    field :thread_id, :string
    field :title, :string
    field :permalink, :string
    field :created_utc, :utc_datetime
    many_to_many :tags, SAS.Tag, join_through: "thread_tags"
  end
end
