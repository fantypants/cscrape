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
      data = perfect_data_set()
      filtered_data = data |> Target.filter_initial_domains
      direct_matches = filtered_data |> Target.direct_matches
      perfect_matches = Target.perfect_matches(filtered_data, direct_matches)

      assert Enum.count(perfect_matches) == 2
    end

    test "test_plausible_matches" do
      data = relevant_data_set()
      filtered_data = data |> Target.filter_initial_domains
      direct_matches = filtered_data |> Target.direct_matches
      plausible_matches = Target.plausible_matches(filtered_data, direct_matches)

      assert Enum.count(plausible_matches) == 2
    end

    test "test_related_matches_only" do
      data = perfect_data_set()
      filtered_data = data |> Target.filter_initial_domains
      direct_matches = filtered_data |> Target.direct_matches
      perfect_matches = Target.perfect_matches(filtered_data, direct_matches)
      related_matches = Target.related_matches(direct_matches, perfect_matches)
      assert Enum.count(related_matches) == 1
    end

    test "test_invalid_git_is_processed" do
      data = realistic_data_set()
      filtered_data = data |> Target.filter_initial_domains
      invalid_returns = filtered_data |> Target.process_invalid
      correct_returns = filtered_data |> Target.remove_invalid
      direct_matches = correct_returns |> Target.direct_matches
      perfect_matches = Target.perfect_matches(correct_returns, direct_matches) |> Target.insert_type_of_match(:perfect)
      related_matches = Target.related_matches(direct_matches, perfect_matches) |> Target.insert_type_of_match(:related)
      plausible_matches = Target.plausible_matches(correct_returns, direct_matches) |> Target.insert_type_of_match(:plausible)
      final_data = perfect_matches ++ related_matches ++ plausible_matches
      direct_and_invalid = invalid_returns |> Target.direct_matches |> Target.insert_type_of_match(:related)
      plausible_and_invalid = Target.invalid_matches(final_data, invalid_returns)
        |> Target.remove_direct(direct_and_invalid)
        |> Target.insert_type_of_match(:plausible)

      data_to_insert = final_data ++ plausible_and_invalid ++ direct_and_invalid

      assert Enum.count(plausible_and_invalid) == 1
    end

    test "test_final_data_is_correct" do
      data = perfect_data_set()
      filtered_data = data |> Target.filter_initial_domains
      direct_matches = filtered_data |> Target.direct_matches
      perfect_matches = Target.perfect_matches(filtered_data, direct_matches) |> Target.insert_type_of_match(:perfect)
      related_matches = Target.related_matches(direct_matches, perfect_matches) |> Target.insert_type_of_match(:related)
      plausible_matches = Target.plausible_matches(filtered_data, direct_matches) |> Target.insert_type_of_match(:plausible)
      final_data = perfect_matches ++ related_matches ++ plausible_matches
      data_contains_perfect = Enum.any?(perfect_matches, fn(perfect) -> perfect.target == "Perfect" end)
      data_contains_related = Enum.any?(related_matches, fn(related) -> related.target == "Related" end)
      data_contains_plausible = Enum.any?(plausible_matches, fn(plausible) -> plausible.target == "Plausible" end)
      assert Enum.count(final_data) == 5
      assert data_contains_perfect && data_contains_related && data_contains_plausible == true
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
        relevancy: 9,
        date: NaiveDateTime.utc_now()
      }end)
    end

    defp perfect_data_set do
      list_a = [
        "coin",
        "blockdaddy",
        "twocents",
      ]
      list_b = [
        "ico",
        "gay",
        "sex",
        "0x88a",
        "twocats"]
    a =  Enum.map(list_a, fn(list) -> %{
        name: list,
        url: "#{list}.network",
        type: ".network",
        relevancy: 9,
        date: NaiveDateTime.utc_now()
      }end)

    b = Enum.map(list_b, fn(list) -> %{
        name: list,
        url: "#{list}.network",
        type: ".network",
        relevancy: 0,
        date: NaiveDateTime.utc_now()
      }end)
      a ++ b
    end

    defp realistic_data_set do
      list_a = [
        "coin",
        "blockdaddy",
        "twocents",
      ]
      list_b = [
        "ico",
        "gay",
        "sex",
        "0x88a",
        "twocats"]
    a =  Enum.map(list_a, fn(list) -> %{
        name: list,
        url: "#{list}.network",
        type: ".network",
        relevancy: 9,
        date: NaiveDateTime.utc_now()
      }end)

    b = Enum.map(list_b, fn(list) -> %{
        name: list,
        url: "#{list}.network",
        type: ".network",
        relevancy: "invalid",
        date: NaiveDateTime.utc_now()
      }end)
      a ++ b
    end



end
