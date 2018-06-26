defmodule Cryptscrape.PageController do
  use Cryptscrape.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def welcome(conn, _params) do
    render conn, "welcome.html"
  end

  def about(conn, _params) do
    render conn, "about.html"
  end

  def faq(conn, _params) do
    render conn, "faq.html"
  end

  def pricing(conn, _params) do
    render conn, "pricing.html"
  end


  def features(conn, _params) do
    render conn, "pricing.html"
  end
end
