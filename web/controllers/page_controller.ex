defmodule Cryptscrape.PageController do
  use Cryptscrape.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
