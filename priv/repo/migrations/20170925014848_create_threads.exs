defmodule SummonerAlerts.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads) do
      add :thread_id, :string
      add :title, :string
    end
  end
end
