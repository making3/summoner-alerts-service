defmodule SAS.TagGroup do
  use Ecto.Schema

  schema "tag_groups" do
    field :name, :string
  end
end
