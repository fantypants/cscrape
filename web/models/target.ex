defmodule Cryptscrape.Target do
  alias Cryptscrape.DomainController
  alias Cryptscrape.Scraper


  def filter_initial_domains(list) do
    list |>
    Enum.reject(fn(list) ->
      String.contains?(list.name, "sex") ||
      String.contains?(list.name, "gay") ||
      String.contains?(list.name, "porn") ||
      String.contains?(list.name, "fuck") == true end) |>
      Enum.reject(fn(list) ->
        Regex.match?(~r/[^a-z][^0-9]/, list.name) == true
      end)
  end

  def insert_matches(map) do
    DomainController.insert_domain(%{"domain" => map})
  end

  def direct_matches(list) do
    identifiers = [
      "coin",
      "block",
      "chain",
      "crypto",
      "cash",
      "tron",
      "ico",
      "eos",
      "eth",
      "bitcoin",
      "btc",
      "token"]
    list |> Enum.reject(fn(list) ->
      String.contains?(list.name, identifiers) == false
    end) |> List.flatten
  end

  def perfect_matches(git_processed_list, direct_matched_list) do
    direct_matched_list |> Enum.reject(fn(list) -> list.relevancy == 0 end) |> Enum.map(fn(direct) ->
      new_list = git_processed_list
      |> Enum.reject(fn(git) -> direct.name !== git.name end)
    end) |> List.flatten
  end

  def related_matches(direct_matched_list, perfect_matched_list) do
    perfect_name_list = perfect_matched_list |> Enum.map(fn(perfect) -> perfect.name end)
    direct_matched_list |> Enum.reject(fn(direct) -> String.contains?(direct.name, perfect_name_list) == true end)
  end


  def plausible_matches(git_processed_list, direct_matched_list) do
    direct_list = direct_matched_list |> Enum.map(fn(direct) -> direct.name end)
    git_processed_list |> Enum.reject(fn(list) ->
      String.contains?(list.name, direct_list) == true
    end) |> List.flatten
  end

  def invalid_matches(final_matched_list, invalid_matched_list) do
    final_name_list = final_matched_list |> Enum.map(fn(final) -> final.name end)
    invalid_matched_list |> Enum.reject(fn(invalid) -> String.contains?(invalid.name, final_name_list) == true end)
  end

  def remove_direct(invalid_matched_list, direct_matched_list) do
    direct_name_list = direct_matched_list |> Enum.map(fn(direct) -> direct.name end)
    invalid_matched_list |> Enum.reject(fn(invalid) -> String.contains?(invalid.name, direct_name_list) == true end)
  end

  def insert_type_of_match(list, type) do
    case type do
      :perfect ->
        list |> Enum.map(fn(list) -> %{
          active: false,
          name: list.name,
          url: list.url,
          type: list.type,
          relevancy: list.relevancy,
          target: "Perfect",
          date: list.date}
        end)
      :related ->
        list |> Enum.map(fn(list) -> %{
          active: false,
          name: list.name,
          url: list.url,
          type: list.type,
          relevancy: list.relevancy,
          target: "Related",
          date: list.date}
        end)
      :plausible ->
        list |> Enum.map(fn(list) -> %{
          active: false,
          name: list.name,
          url: list.url,
          type: list.type,
          relevancy: list.relevancy,
          target: "Plausible",
          date: list.date}
        end)
    end
  end

  def remove_invalid(map) do
    map |> Enum.reject(fn(a) -> a.relevancy == "invalid" end)
  end

  def process_invalid(map) do
  map |> Enum.reject(fn(a) -> a.relevancy !== "invalid" end)
      |> Enum.map(fn(list) -> %{
        active: false,
        name: list.name,
        url: list.url,
        type: list.type,
        relevancy: 0,
        date: list.date}
      end)
  end
end
