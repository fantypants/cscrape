defmodule Cryptscrape.DomainTest do
  use Cryptscrape.ModelCase

  alias Cryptscrape.Domain

  @valid_attrs %{date: "some date", name: "some name", type: "some type", url: "some url"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Domain.changeset(%Domain{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Domain.changeset(%Domain{}, @invalid_attrs)
    refute changeset.valid?
  end
end
