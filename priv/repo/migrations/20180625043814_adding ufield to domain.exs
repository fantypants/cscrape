defmodule :"Elixir.Cryptscrape.Repo.Migrations.Adding ufield to domain" do
  use Ecto.Migration

  def change do
      create unique_index(:domains, [:name])
  end
end
