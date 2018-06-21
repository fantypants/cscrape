defmodule :"Elixir.Cryptscrape.Repo.Migrations.Adding Relevancy Score to the url" do
  use Ecto.Migration

  def change do
    alter table(:domains) do
      add :relevancy, :integer
    end
  end
end
