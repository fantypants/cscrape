defmodule Cryptscrape.ScraperTest do
  use Cryptscrape.ModelCase
    alias Cryptscrape.Target
    alias Cryptscrape.Scrape

    test "test_initial_filter" do
      data = data_set() #Fetch Initial Data Set
      test_case = data |> Target.filter_initial_domains
      test_case_size = test_case |> Enum.count()
      assert test_case_size == 5
    end

    test "test_direct_match_filter" do
      data = data_set()
      filtered_data = data |> Target.filter_initial_domains
      test_case = filtered_data |> Target.direct_matches
      test_case_size = test_case |> Enum.count()
      assert test_case_size == 3
    end

    test "test_perfect_matches" do
      data = relevant_data_set()
      filtered_data = data |> Target.filter_initial_domains
      direct_matches = filtered_data |> Target.direct_matches
      perfect_matches = Target.perfect_matches(filtered_data, direct_matches)

      assert Enum.count(perfect_matches) == 3
    end

    test "test_plausible_matches" do
      data = relevant_data_set()
      filtered_data = data |> Target.filter_initial_domains
      direct_matches = filtered_data |> Target.direct_matches
      plausible_matches = Target.plausible_matches(filtered_data, direct_matches)

      assert Enum.count(plausible_matches) == 2

    end

    defp data_set do
      list = [
        "coin",
        "blockdaddy",
        "twocents",
        "ico",
        "gay",
        "sex",
        "0x88a",
        "twocats"]
      Enum.map(list, fn(list) -> %{
        name: list,
        url: "#{list}.network",
        type: ".network",
        date: NaiveDateTime.utc_now()
      }end)
    end

    defp relevant_data_set do
      list = [
        "coin",
        "blockdaddy",
        "twocents",
        "ico",
        "gay",
        "sex",
        "0x88a",
        "twocats"]
      Enum.map(list, fn(list) -> %{
        name: list,
        url: "#{list}.network",
        type: ".network",
        relevancy: 99,
        date: NaiveDateTime.utc_now()
      }end)
    end


end
