defmodule :"Elixir.Cryptscrape.Repo.Migrations.Adding relations to the poll" do
  use Ecto.Migration

  def change do
    alter table(:votes) do
      add :user_id, references(:users, on_delete: :nothing)
      add :domain_id, references(:domains, on_delete: :nothing)
    end
  end
end
