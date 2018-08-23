defmodule Cryptscrape.FindValid do

def run_domain_verification(url_list) do
  url_list |> Enum.map(fn(url) -> %{
    name: url,
    active?: get_page_name(url)
  }end)
end

def get_page_name(url) do
with true <- check_response(url) do
  check_page(url)
end
end

def check_response(url) do
  request = HTTPoison.get!(url,[], follow_redirect: true)
  case request.status_code do
    200 -> true
    301 -> true
    _-> false
  end
end

def check_header(url) do
request = HTTPoison.get!(url,[], follow_redirect: true)
case request.status_code do
  200 -> get_page_title(request.body, url)
  _-> false
end
end

def check_meta(url) do
request = HTTPoison.get!(url,[], follow_redirect: true)
case request.status_code do
  200 -> get_meta_title(request.body, url)
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
end

page_has_title
end

defp get_page_title(body, url) do
  valid_title = String.replace(url, ".network", "")
  url_title = HTTPoison.process_request_body(body)
    |> Floki.find("title")
  case url_title do
    [] -> false
    _->
    extracted_title = url_title
      |> List.first
      |> elem(2)
      |> List.first
      |> String.downcase
  correct_title? = String.contains?(extracted_title, valid_title)
  check_if_type_exists = String.contains?(extracted_title, "network")
  case check_if_type_exists do
    true ->
      valid = false
    false ->
      valid = correct_title?
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
