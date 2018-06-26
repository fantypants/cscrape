defmodule Cryptscrape.Target do
  alias Cryptscrape.DomainController
  alias Cryptscrape.Scraper

  #Compare with results from git
  #Combined Results List
  #Non Combined Results List

  #Perfect List
  #Plausable
  #Watch




  def direct_matches(list) do
    list |> Enum.map(fn(a) -> search_names(a) end) |> List.flatten |> Enum.reject(fn(a) -> a.valid == false end) |> IO.inspect
  end

  def perfect_matches(git_list, direct_list) do
    git_list |> Enum.map(fn(a) -> compare_git(a, direct_list) end) |> List.flatten |> Enum.reject(fn(a) -> a.valid? == false end) |> Enum.reject(fn(a) -> a.relevancy == nil end) |> IO.inspect
  end

  def watch_list(list) do

    
  end

  defp search_names(name) do
    identifiers = [
      "coin",
      "block",
      "chain",
      "crypto",
      "cash",
      "tron",
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
        date: name.date
        } end)
  end

  defp compare_git(git_map, direct_list) do
    #%{name: a.name, type: a.type, url: a.url, date: a.date, relevancy: map}
    git_name = git_map.name
    direct_list |> Enum.map(fn(a) -> %{
      valid?: String.contains?(a.name, git_name),
      type: git_map.type,
      url: git_map.url,
      date: git_map.date,
      name: git_map.name,
      relevancy: git_map.relevancy
    } end)

  end




end
