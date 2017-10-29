defmodule SAS.Repo.Migrations.UniqueTitle do
  use Ecto.Migration

  def change do
    alter table(:threads) do
      modify :thread_id, :string, unique: true
    end
  end
end
