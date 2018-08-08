defmodule Cryptscrape.Repo.Migrations.CreateNegvote do
  use Ecto.Migration

  def change do
    create table(:negvotes) do
      add :value, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :domain_id, references(:domains, on_delete: :nothing)

      timestamps()
    end
  end
end
