defmodule Cryptscrape.VoteTest do
  use Cryptscrape.ModelCase

  alias Cryptscrape.Vote

  @valid_attrs %{value: "some value"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vote.changeset(%Vote{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vote.changeset(%Vote{}, @invalid_attrs)
    refute changeset.valid?
  end
end
