defmodule Cryptscrape.Vote do
  use Cryptscrape.Web, :model

  schema "votes" do
    field :value, :string

      belongs_to :user, Cryptscrape.User
      belongs_to :domain, Cryptscrape.Domain
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value, :user_id, :domain_id])
    |> validate_required([:value, :user_id, :domain_id])
  end
end
