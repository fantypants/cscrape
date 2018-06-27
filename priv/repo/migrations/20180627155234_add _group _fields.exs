defmodule :"Elixir.Cryptscrape.Repo.Migrations.Add Group Fields" do
  use Ecto.Migration

  def change do
    alter table(:domains) do
      add :target, :string
    end
  end
end
