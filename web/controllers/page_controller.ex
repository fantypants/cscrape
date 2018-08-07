defmodule Cryptscrape.PageController do
  use Cryptscrape.Web, :controller
  alias Cryptscrape.Article
  alias Cryptscrape.Domain

  def index(conn, _params) do
    direct_query = from d in Domain, where: d.target == ^"Direct"
    potential_query = from d in Domain, where: d.target == ^"Potential"
    watch_query = from d in Domain, where: d.target == ^"Watch"
    direct = Repo.all(direct_query) |> Repo.preload(:votes) |> Enum.uniq_by(fn(a) -> a.name end) |> Enum.take(5) |> IO.inspect
    potential = Repo.all(potential_query) |> Repo.preload(:votes) |> Enum.uniq_by(fn(a) -> a.name end) |> Enum.take(5) |> IO.inspect
    watch = Repo.all(watch_query) |> Repo.preload(:votes) |> Enum.uniq_by(fn(a) -> a.name end) |> Enum.take(5) |> IO.inspect
    #Article.get_information(:medium, "tronpay")
    render conn, "index.html", direct: direct, potential: potential, watch: watch
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
