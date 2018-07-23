defmodule Cryptscrape.Article do
  use Cryptscrape.Web, :model
  alias Cryptscrape.Article

  def get_latest_articles(provider, domain) do
    #GETS LATREST ARTICLES FROM PROVIDER

    case provider do
      :medium ->
        IO.puts "Get Articles From Medium"
    end

  end

  def get_information(provider, domain) do
    case provider do
      :medium ->
        IO.puts "Get recent members from Medium"
    end
  end

end
