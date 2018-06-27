defmodule Cryptscrape.Domain do
  use Cryptscrape.Web, :model
  alias Cryptoscrape.Scraper

  schema "domains" do
    field :name, :string
    field :date, :naive_datetime
    field :type, :string
    field :url, :string
    field :target, :string
    field :relevancy, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :date, :type, :url, :relevancy, :target])
    |> unique_constraint(:name)
    |> validate_required([:name, :date, :type, :url, :relevancy, :target])
  end
end
