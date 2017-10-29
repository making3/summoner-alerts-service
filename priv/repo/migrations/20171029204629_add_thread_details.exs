defmodule SAS.Repo.Migrations.AddThreadDetails do
  use Ecto.Migration

  def change do
    alter table(:threads) do
      add :permalink, :string
      add :created_utc, :utc_datetime
    end
  end
end
