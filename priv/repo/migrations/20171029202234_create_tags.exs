defmodule SAS.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tag_groups) do
      add :name, :string
    end

    create table(:tags) do
      add :name, :string
      add :tag_group_id, references(:tag_groups)
    end

    create table(:thread_tags) do
      add :thread_id, references(:threads)
      add :tag_id, references(:tags)
    end
  end
end
