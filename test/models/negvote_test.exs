defmodule Cryptscrape.NegvoteTest do
  use Cryptscrape.ModelCase

  alias Cryptscrape.Negvote

  @valid_attrs %{value: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Negvote.changeset(%Negvote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Negvote.changeset(%Negvote{}, @invalid_attrs)
    refute changeset.valid?
  end
end
