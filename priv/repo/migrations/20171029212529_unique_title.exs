defmodule SAS.Repo.Migrations.UniqueTitle do
  use Ecto.Migration

  def change do
    alter table(:threads) do
      modify :title, :string, unique: true, size: 300
    end
  end
end
