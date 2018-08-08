defmodule :"Elixir.Cryptscrape.Repo.Migrations.Adding Admin to users" do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :auth_level, :boolean
    end
  end
end
