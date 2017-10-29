defmodule SAS.Tag do
  use Ecto.Schema
  schema "tags" do
    field :name, :string
    belongs_to :tag_group, TagGroup
  end
end
