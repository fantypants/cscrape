defmodule Cryptscrape.Scraper do
  alias Cryptscrape.DomainController
  alias Cryptscrape.Target

def runlist() do
      list = newlist
      filtered_list = Target.filter_initial_domains(list)
      raw_list = scrapegit(filtered_list)
      direct_list = filtered_list |> Target.direct_matches
      perfect_matches = Target.perfect_matches(raw_list, direct_list)
      pending_matches = Target.watch_list(perfect_matches, raw_list)
      direct_list |> Enum.map(fn(a) -> Target.insert_matches(a) end)
      perfect_matches |> Enum.map(fn(a) -> Target.insert_matches(a) end)
      pending_matches |> Enum.map(fn(a) -> Target.insert_matches(a) end)
      #raw_list = scrapegit(list) |> IO.inspect
      #for_submission = remove_entries(raw_list) |> IO.inspect
end

defp newlist() do
user = Application.get_env(:cryptscrape, Cryptscrape.Endpoint)[:user]
pass = Application.get_env(:cryptscrape, Cryptscrape.Endpoint)[:pass]
#url = "https://domainlists.io/api/newdns/962/#{user}/#{pass}/"
url = "https://domainlists.io/api/new/100/matthewmjeaton@gmail.com/Eato0810a!/"
response = HTTPotion.get(url)
case response do
  %HTTPotion.Response{} ->
    map = response.body |> splitdomain
  %HTTPotion.ErrorResponse{} ->
    IO.puts "doesnt work"
end
end

defp remove_entries(map) do
map |> Enum.reject(fn(a) -> a.relevancy == "invalid" end)
end

defp splitdomain(list) do
  url = list
  |> String.split("\n")
  name = url |> Enum.map(fn(a) -> %{
    url: a,
    name: List.first(String.split(a, ".network")),
    type: ".network",
    date: NaiveDateTime.utc_now()
    } end)
end

defp scrapegit(list) do
  list |> Enum.map(fn(a) ->
    case processgit(a.name) do
      {:ok, map} ->
        %{name: a.name, type: a.type, url: a.url, date: a.date, relevancy: map}
      {:error, message} ->
        %{name: a.name, type: a.type, url: a.url, date: a.date, relevancy: "invalid"} |> IO.inspect
    end
  end)
end

defp processgit(name) do
  :timer.sleep(2500)
  IO.inspect name
  token = Application.get_env(:cryptscrape, Cryptscrape.Endpoint)[:git]
  url = "https://api.github.com/search/repositories?q=#{name}&in:name" |> IO.inspect
  headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json; Charset=utf-8", "User-Agent": "fantypants"]
  options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
  response = HTTPoison.get(url, headers, options)
  case response do
    {:ok, payload} ->
      gitresponse = payload.body |> Poison.decode!
      valid? = gitresponse["total_count"]
      case valid? do
        0 ->
          {:error, "Nothing Exists"}
        _->
          {:ok, valid?}
      end
      {:error, message} ->
        {:error, "Timed Out"}
    _->
    {:error, "Error in RPC Call"}
  end
end



end
