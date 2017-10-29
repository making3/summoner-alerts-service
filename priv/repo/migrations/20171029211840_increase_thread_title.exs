defmodule SAS.Repo.Migrations.IncreaseThreadTitle do
  use Ecto.Migration

  def change do
    alter table(:threads) do
      modify :title, :string, size: 300
    end
  end
end
