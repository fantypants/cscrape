defmodule :"Elixir.Cryptscrape.Repo.Migrations.Altering date" do
  use Ecto.Migration

  def change do
    alter table(:domains) do
      remove :date
      add :date, :naive_datetime
    end
  end
end
