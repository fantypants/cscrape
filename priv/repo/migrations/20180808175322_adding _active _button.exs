defmodule :"Elixir.Cryptscrape.Repo.Migrations.Adding Active Button" do
  use Ecto.Migration

  def change do
    alter table(:domains) do
      add :active, :boolean
    end
  end
end
