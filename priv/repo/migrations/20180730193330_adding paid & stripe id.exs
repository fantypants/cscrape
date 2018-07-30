defmodule :"Elixir.Cryptscrape.Repo.Migrations.Adding paid & stripe id" do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :paid, :boolean
      add :stripe_id, :string

    end

  end
end
