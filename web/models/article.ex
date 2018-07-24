defmodule Cryptscrape.Article do
  use Cryptscrape.Web, :model
  alias Cryptscrape.Article


  def get_information(provider, domain) do
    case provider do
      :medium ->
        #Gets All Information From Medium
        articles = get_latest_articles(provider, domain) |> IO.inspect
        people = get_people(provider, domain)
    end
  end
  defp get_latest_articles(provider, domain) do
    #GETS LATREST ARTICLES FROM PROVIDER
    case provider do
      :medium ->
        medium_articles(domain)
    end
  end

  defp get_people(provider, domain) do
    #GETS Users from Medium
    case provider do
      :medium ->
        medium_people(domain)
    end
  end

  defp medium_people(domain) do
    url = "https://medium.com/search/users?q=" <> domain
    get_request(url)
  end

  defp medium_articles(domain) do
    url = "https://medium.com/tag/" <> domain <> "/latest"
    get_request(url)
  end

  defp get_request(url) do
    response = HTTPotion.get(url)
    success? = HTTPotion.Response.success?(response)
    case success? do
      true ->
        scrape_response(:article, response.body)
        #scrape_response(:people, response.body)
      false ->
        scrape_response(:people, response.body)
    end
  end

  defp scrape_response(type, response) do
    #Chooses the path on which we want to scrape
    case type do
      :article ->
        extract_articles(response)
      :people ->
        extract_people(response)
    end
  end

  defp extract_articles(response) do
    #Extracts the article information
    articles = response |> Friendly.find("a") |> Enum.map(fn article ->
      %{article: article.attributes["title"]}
    end) |> Enum.uniq
  end

  defp extract_people(response) do
    users = response |> Friendly.find("a") |> Enum.map(fn user ->
      %{users: user.attributes["title"]}
    end) |> Enum.uniq
  end

end
