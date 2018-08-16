#old
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

#OLD
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


  #old
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

  #old
  def perfect_matches(git_list, direct_list) do
    git_list |> Enum.map(fn(a) -> compare_git(a, direct_list) end)
    |> List.flatten
    |> Enum.reject(fn(a) -> a.valid? == false end)
    |> Enum.reject(fn(a) -> a.relevancy == nil end)
  end

  #old
  def watch_list(perfect_list, git_list) do
    git_list |> Enum.map(fn(a) -> filter_perfect_matches(a, perfect_list) end)
    |> List.flatten
    |> Enum.reject(fn(a) -> a.valid? !== false end)
    |> Enum.reject(fn(a) -> a.relevancy == "invalid" end)
    |> Enum.uniq
  end

  #OLD
  defp filter_integers(map) do
    case Regex.match?(~r/[^0-9]/, map.name) do
      false ->
        IO.inspect map.name
        IO.puts "Shit Domain, contains crap"
        %{
          url: "invalid",
          name: map.name,
          type: ".network",
          date: map.date
          }
      true ->
        IO.inspect map.name
        IO.puts "Solid Domain, no shit"
        %{
          url: map.url,
          name: map.name,
          type: ".network",
          date: map.date
          }
    end

  end

  #OLD
  def direct_matches_old(list) do
    list |> Enum.map(fn(a) -> search_names(a) end)
    |> List.flatten
    |> Enum.reject(fn(a) -> a.valid == false end)
  end

  #OLD
  def filter_initial_domains_outdated(list) do
    IO.puts "Main Domain Filter"
    valid_list = list |> Enum.map(fn(a) -> filter_integers(a) end) |> Enum.reject(fn(a) -> a.url == "invalid" end)
    valid_list
  end
