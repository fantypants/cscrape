defmodule Cryptscrape.Scraper do
  alias Cryptscrape.DomainController
  alias Cryptscrape.Target


def runlist() do
  data = newlist
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
  data_to_insert |> Enum.map(fn(a) -> Target.insert_matches(a) end)
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
    IO.inspect response
end
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
