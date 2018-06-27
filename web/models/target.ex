defmodule Cryptscrape.Target do
  alias Cryptscrape.DomainController
  alias Cryptscrape.Scraper

  #Compare with results from git
  #Combined Results List
  #Non Combined Results List

  #Perfect List
  #Plausable
  #Watch

  def insert_matches(map) do
    DomainController.insert_domain(%{"domain" => map})
  end

  def direct_matches(list) do
    list |> Enum.map(fn(a) -> search_names(a) end)
    |> List.flatten
    |> Enum.reject(fn(a) -> a.valid == false end)
  end

  def perfect_matches(git_list, direct_list) do
    IO.puts "IN PErfect Match"
    IO.inspect git_list
    git_list |> Enum.map(fn(a) -> compare_git(a, direct_list) end)
    |> List.flatten
    |> Enum.reject(fn(a) -> a.valid? == false end)
    |> Enum.reject(fn(a) -> a.relevancy == nil end)
  end

  def watch_list(perfect_list, git_list) do
    git_list |> Enum.map(fn(a) -> filter_perfect_matches(a, perfect_list) end)
    |> List.flatten
    |> Enum.reject(fn(a) -> a.valid? !== false end)
    |> Enum.reject(fn(a) -> a.relevancy == "invalid" end)
    |> Enum.uniq
  end

  defp filter_perfect_matches(raw_map, perfect_list) do
    #THIS FINDS ALL GIT RETURNED MATCHES WHICH ARENT IN THE PERFECT MATCH CATEGORY
    target_name = raw_map.name
    perfect_list |> Enum.map(fn(a) -> %{
      valid?: String.contains?(a.name, target_name),
      name: raw_map.name,
      url: raw_map.url,
      type: raw_map.type,
      relevancy: raw_map.relevancy,
      target: "Potential",
      date: raw_map.date
    }end)
  end

  defp search_names(name) do
    #THIS FINDS ALL DIRECT ICO RELATED MATCHES
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
      contains? = identifiers |> Enum.map(fn(a) -> %{
        valid: String.contains?(name.name, a),
        name: name.name,
        url: name.url,
        type: name.type,
        relevancy: 0,
        target: "Direct",
        date: name.date
        } end)
  end

  defp compare_git(git_map, direct_list) do
    #THIS FINDS ALL MATCHES RETURNED FROM THE GIT SCRAPE AND ALSO IN THE DIRECT MATCHES, THIS CREATES PERFECT MATCHES
    #%{name: a.name, type: a.type, url: a.url, date: a.date, relevancy: map}
    git_name = git_map.name
    direct_list |> Enum.map(fn(a) -> %{
      valid?: String.contains?(a.name, git_name),
      type: git_map.type,
      url: git_map.url,
      date: git_map.date,
      target: "Watch",
      name: git_map.name,
      relevancy: git_map.relevancy
    } end)

  end




end
