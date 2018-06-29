defmodule Cryptscrape.Vote do
  use Cryptscrape.Web, :model

  schema "votes" do
    field :value, :integer
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

  def create_vote(%{"user" => user_id, "domain" => domain_id, "value" => value}) do
    vote_params = %{
      "user_id" => user_id,
      "domain_id" => domain_id,
      "value" => value
      }
  #  changeset = changeset(%Vote{}, vote_params)

    case Repo.insert(vote_params) do
      {:ok, vote} ->
        IO.puts "Vote added Successfully"
      {:error, vote_params} ->
        IO.puts "Vote not added"
    end
  end
end
