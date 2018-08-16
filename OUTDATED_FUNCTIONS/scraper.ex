def runlist_OLD() do
  case getToken() do
    {:ok, key} ->
      list = getlist(key)
      #scrapegit(list)

    {:error, key}
      IO.puts "Error, Quit"
  end
end

defp getToken() do
  secret = Application.get_env(:cryptscrape, Cryptscrape.Endpoint)[:secretkey]
  token = Application.get_env(:cryptscrape, Cryptscrape.Endpoint)[:accesskey]
  authurl = "https://api.codepunch.com/dnfeed.php?c=auth&k=#{token}&s=#{secret}"
  response = HTTPotion.get(authurl)
  case response do
    %HTTPotion.Response{} ->
      raw_key = response.body
      |> String.split("OK:")
      key = List.last(raw_key) |> String.trim
      {:ok, key}
    %HTTPotion.ErrorResponse{} ->
      IO.puts "Didnt work"
      key = "error"
      {:error, key}
  end
end


defp getlist(key) do
  count = check_count(key) |> IO.inspect
  i_url = "https://api.codepunch.com/dnfeed.php?t=#{key}&start=2000&limit=3000&f=xml"
  url = "https://api.codepunch.com/dnfeed.php?t=#{key}&z=io&f=xml"
  response = HTTPotion.get(url) |> IO.inspect
  case response do
    %HTTPotion.Response{} ->
    raw_date = Friendly.find(response.body, "date") |> Enum.uniq
    date = List.first(raw_date).text |> IO.inspect
    domains_raw = Friendly.find(response.body, "domain") |> IO.inspect
    domains = Enum.map(domains_raw, fn(a) -> %{
      name: Enum.find(a.elements, fn(b) -> b.name == "name" end).text,
      type: Enum.find(a.elements, fn(b) -> b.name == "tld" end).text,
      url: "www.#{Enum.find(a.elements, fn(b) -> b.name == "name" end).text}.#{Enum.find(a.elements, fn(b) -> b.name == "tld" end).text}",
      date: Enum.find(a.elements, fn(b) -> b.name == "date" end).text
    }end)
    %HTTPotion.ErrorResponse{} ->
    IO.puts "Error in Grabbing List"
  end
end


defp check_count(key) do
url = "https://api.codepunch.com/dnfeed.php?t=#{key}&z=network&m=stats"
response = HTTPotion.get(url) |> IO.inspect
  case response do
    %HTTPotion.Response{} ->
      IO.inspect response.body
    %HTTPotion.ErrorResponse{} ->
      IO.puts "Error"
  end
end


#old
defp remove_entries(map) do
map |> Enum.reject(fn(a) -> a.relevancy == "invalid" end)
end


#old
def remove_duplicates(filtered_list, targetted_list) do
  targetted_list |> Enum.map(fn(a) ->
    new_list = filtered_list
    |> Enum.reject(fn(b) -> b.name == a.name end)
  end)
end


#OLD
def runlist_old() do

  #Perfect Matches are Direct hits with github
      list = newlist
      filtered_list = Target.filter_initial_domains(list)
      raw_list = scrapegit(filtered_list)
      direct_list = filtered_list |> Target.direct_matches
      raw_list_without_direct = remove_duplicates(raw_list, direct_list)
      perfect_matches = Target.perfect_matches(raw_list, direct_list)
      pending_matches = Target.watch_list(perfect_matches, raw_list)
      perfect = perfect_matches |> Enum.map(fn(a) -> Target.insert_matches(a) end)
      direct = remove_duplicates(direct_list, perfect_matches) |> List.flatten |> Enum.map(fn(a) -> Target.insert_matches(a) end)
      # NEED TO FIX pending = remove_duplicates(pending_matches, direct_list) |> List.flatten |> Enum.map(fn(a) -> Target.insert_matches(a) end)
      pending  = pending_matches |> Enum.map(fn(a) -> Target.insert_matches(a) end)
      IO.puts "#### Stats ####"
      IO.puts "FILTERED: #{Enum.count(filtered_list)}"
      IO.puts "DIRECT: #{Enum.count(direct)}"
      IO.puts "PERFECT: #{Enum.count(perfect)}"
      IO.puts "PENDING: #{Enum.count(pending)}"

end
