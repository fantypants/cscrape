defmodule Cryptscrape.Repo.Migrations.CreateDomain do
  use Ecto.Migration

  def change do
    create table(:domains) do
      add :name, :string
      add :date, :string
      add :type, :string
      add :url, :string

      timestamps()
    end
  end
end
