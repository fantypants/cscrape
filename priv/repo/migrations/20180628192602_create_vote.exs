defmodule Cryptscrape.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :value, :string

      timestamps()
    end
  end
end
