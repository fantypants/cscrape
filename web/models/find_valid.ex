defmodule Cryptscrape.FindValid do
  import Ecto.Query

  alias Cryptscrape.Domain



def run_domain_verification(url_list) do
  url_list |> Enum.map(fn(url) -> %{
    url: url,
    active?: check_page(url)
  }end) |> update_db
end

defp update_db(map) do
  map
  |> Enum.reject(fn(domain) -> domain.active? == false end)
  |> Enum.map(fn(domain) -> update_domain(domain.url) end)
end

defp update_domain(url) do
  domain_id = Cryptscrape.Repo.all(from d in Domain, where: d.url == ^url, select: d.id) |> List.first
  domain = Cryptscrape.Repo.get!(Domain, domain_id)
  case domain do
    nil ->
      {:error, "Domain Not Found"}
    _->
    domain = Ecto.Changeset.change domain, active: true
    case Cryptscrape.Repo.update domain do
      {:ok, struct}       -> IO.puts "Success, Domain Now Active"
      {:error, changeset} -> IO.puts "Incorrect, Domain not Active"
    end
  end
end

def get_page_name(url) do
  IO.inspect url
with true <- check_response(url) do
  check_page(url)
end
end

def check_response(url) do
  options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 1500, follow_redirect: true, max_redirect: 50, force_redirect: true]
  case HTTPoison.get(url, [], options) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      true
      {:ok, %HTTPoison.Response{body: body}} ->
        true
    {:ok, %HTTPoison.Response{status_code: 404}} ->
      false
    {:error, %HTTPoison.Error{reason: reason}} ->
      false
    {:closed, %HTTPoison.Error{reason: reason}} ->
      false
    {:max_redirect_overflow, %HTTPoison.Error{reason: reason}} ->
      false
  end
end


def check_header(url) do
  options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 1500, follow_redirect: true, max_redirect: 50, force_redirect: true]
  case HTTPoison.get(url, [], options) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      get_page_title(body, url)
      {:ok, %HTTPoison.Response{body: body}} ->
        get_page_title(body, url)
    {:ok, %HTTPoison.Response{status_code: 404}} ->
      IO.puts "Not found :("
    {:error, %HTTPoison.Error{reason: reason}} ->
      false
    {:closed, %HTTPoison.Error{reason: reason}} ->
      false
    {:max_redirect_overflow, %HTTPoison.Error{reason: reason}} ->
      false
  end
end
#EXPIRED
def check_old_header(url) do
  IO.inspect url
options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 1500, follow_redirect: true, max_redirect: 5, force_redirect: true]
request = HTTPoison.get!(url,[], options) |> IO.inspect
case request.status_code do
  200 -> get_page_title(request.body, url)
  301 -> get_page_title(request.body, url)
  nil -> nil
  _-> false
end
end


def check_meta(url) do
  options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 1500, follow_redirect: true, max_redirect: 50, force_redirect: true]
  case HTTPoison.get(url, [], options) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      get_meta_title(body, url)
      {:ok, %HTTPoison.Response{body: body}} ->
      get_meta_title(body, url)
    {:ok, %HTTPoison.Response{status_code: 404}} ->
      IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        false
      {:closed, %HTTPoison.Error{reason: reason}} ->
        false
      {:max_redirect_overflow, %HTTPoison.Error{reason: reason}} ->
        false
  end
end

def check_old_meta(url) do
  options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 1500, follow_redirect: true, max_redirect: 2]
request = HTTPoison.get!(url,[], options)
      case request.status_code do
         200 -> get_meta_title(request.body, url)
         301 -> get_meta_title(request.body, url)
         _-> false
       end
end

def check_page(url) do
has_header? = check_header(url)
case has_header? do
  true ->
    page_has_title = true
  false ->
    page_has_title = check_meta(url)
  nil -> page_has_title = false
end

page_has_title
end

defp get_page_title(body, url) do
  IO.inspect body
  valid_title = String.replace(url, ".network", "")
  url_title = HTTPoison.process_request_body(body)
    |> Floki.find("title")
  case url_title do
    [] -> valid = false
    nil -> valid = false
    _->
    extracted_title = url_title
      |> List.first
      |> elem(2)
  case extracted_title do
      nil -> valid = false
      [] -> valid = false
      _->
    title = extracted_title
      |> List.first
      |> String.downcase
      correct_title? = String.contains?(title, valid_title)
      check_if_type_exists = String.contains?(title, "network")
      case check_if_type_exists do
        true ->
          valid = false
        false ->
          valid = correct_title?
      end
  end
  valid
end

end

defp get_meta_title(body, url) do
  valid_title = String.replace(url, ".network", "")
  HTTPoison.process_request_body(body)
      |> Floki.find("meta")
      |> Floki.attribute("content")
      |> Enum.member?(valid_title)
end

end
