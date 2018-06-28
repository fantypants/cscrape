defmodule :"Elixir.Cryptscrape.Repo.Migrations.Chaning vote to integer" do
  use Ecto.Migration

  def change do
    alter table(:votes) do
      remove :value
      add :value, :integer
    end
  end
end
