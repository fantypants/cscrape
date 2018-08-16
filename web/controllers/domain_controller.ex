defmodule Cryptscrape.DomainController do
  use Cryptscrape.Web, :controller

  alias Cryptscrape.Domain
  alias Cryptscrape.Vote
  alias Cryptscrape.Negvote
  alias Cryptscrape.Accounts

  def index(conn, _params) do
    domains = Repo.all(Domain) |> Repo.preload(:votes) |> Enum.sort_by(fn(a) -> a.name end) |> Enum.reverse
    render(conn, "index.html", domains: domains)
  end

  def edit_domains(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
    domains = Repo.all(Domain) |> Repo.preload(:votes) |> Enum.sort_by(fn(a) -> a.name end) |> Enum.reverse
    render(conn, "edit_domains.html", domains: domains)
  end

  def count_votes(domain) do
    query = from v in Vote, where: v.domain_id == ^domain
    Repo.all(query) |> Enum.count
  end

  def count_negvotes(domain) do
    query = from v in Negvote, where: v.domain_id == ^domain
    Repo.all(query) |> Enum.count
  end

  def watch_index(conn, _params) do
    domains = Repo.all(from d in Domain, where: d.target == ^"Plausible") |> Repo.preload(:votes) |> Enum.sort_by(fn(a) -> a.relevancy end) |> Enum.reverse
    conn |> render("watch_index.html", domains: domains)
  end

  def potential_index(conn, _params) do
    domains = Repo.all(from d in Domain, where: d.target == ^"Perfect") |> Repo.preload(:votes) |> Enum.sort_by(fn(a) -> a.relevancy end) |> Enum.reverse
    conn |> render("potential_index.html", domains: domains)
  end

  def direct_index(conn, _params) do
    domains = Repo.all(from d in Domain, where: d.target == ^"Related") |> Repo.preload(:votes) |> Enum.sort_by(fn(a) -> a.relevancy end) |> Enum.reverse
    conn |> render("direct_index.html", domains: domains)
  end


  def new(conn, _params) do
    changeset = Domain.changeset(%Domain{})
    render(conn, "new.html", changeset: changeset)
  end

  def run_list() do
    Task.async(fn -> Cryptscrape.Scraper.runlist() end)
  end

  defp create_vote(%{"user" => user_id, "domain" => domain_id, "value" => value}) do
    vote_params = %{
      "user_id" => user_id,
      "domain_id" => domain_id,
      "value" => +1
      }
   changeset = Vote.changeset(%Vote{}, vote_params)

    case Repo.insert(changeset) do
      {:ok, vote} ->
        IO.puts "Vote added Successfully"
      {:error, vote_params} ->
        IO.puts "Vote not added"
    end
  end

  def add_vote(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id"=> domain_id}) do
    IO.puts "First stage of adding vote"
    IO.inspect user.id
    IO.inspect domain_id
    create_vote(%{"user" => user.id, "domain" => domain_id, "value" => +1})
    conn
    |> put_flash(:info, "Vote added!")
    |> redirect(to: domain_path(conn, :index))
  end

  defp create_negvote(%{"user" => user_id, "domain" => domain_id, "value" => value}) do
    vote_params = %{
      "user_id" => user_id,
      "domain_id" => domain_id,
      "value" => -1
      }
   changeset = Negvote.changeset(%Negvote{}, vote_params)
    case Repo.insert(changeset) do
      {:ok, vote} ->
        IO.puts "Vote added Successfully"
      {:error, vote_params} ->
        IO.puts "Vote not added"
    end
  end

  def add_negvote(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id"=> domain_id}) do
    IO.puts "First stage of adding Negative vote"
    IO.inspect user.id
    IO.inspect domain_id
    create_negvote(%{"user" => user.id, "domain" => domain_id, "value" => -1})
    conn
    |> put_flash(:info, "Vote added!")
    |> redirect(to: domain_path(conn, :index))
  end

  def generatelist(conn, _params) do
    IO.puts "Start of generating list"
    Task.async(fn -> Cryptscrape.Scraper.runlist() end)
    render(conn, "running.html")
  end

  def create(conn, %{"domain" => domain_params}) do
    changeset = Domain.changeset(%Domain{}, domain_params)

    case Repo.insert(changeset) do
      {:ok, domain} ->
        conn
        |> put_flash(:info, "Domain created successfully.")
        |> redirect(to: domain_path(conn, :show, domain))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def insert_domain(%{"domain" => domain_params}) do
    changeset = Domain.changeset(%Domain{}, domain_params)
    case Repo.insert(changeset) do
      {:ok, domain} ->
        IO.puts "Inserted Domain"
      {:error, changeset} ->
        IO.puts "Error"
    end
  end

  defp make_domain_active(%{"user" => user_id, "domain" => domain_id}) do
    IO.puts "making Domain Active"
    domain = Repo.get!(Domain, domain_id)
    case domain do
      nil ->
        {:error, "Domain Not Found"}
      _->
      domain = Ecto.Changeset.change domain, active: true
      case Repo.update domain do
        {:ok, struct}       -> IO.puts "Success, Domain Now Active"
        {:error, changeset} -> IO.puts "Incorrect, Domain not Active"
      end
    end
  end

  def make_active(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    make_domain_active(%{"user" => user.id, "domain" => id})
    conn
    |> put_flash(:info, "Domain Made Active!")
    |> redirect(to: domain_path(conn, :edit_domains, user.id))

  end

  def show(conn, %{"id" => id}) do
    domain = Repo.get!(Domain, id)
    render(conn, "show.html", domain: domain)
  end

  def edit(conn, %{"id" => id}) do
    domain = Repo.get!(Domain, id)
    changeset = Domain.changeset(domain)
    render(conn, "edit.html", domain: domain, changeset: changeset)
  end

  def update(conn, %{"id" => id, "domain" => domain_params}) do
    domain = Repo.get!(Domain, id)
    changeset = Domain.changeset(domain, domain_params)

    case Repo.update(changeset) do
      {:ok, domain} ->
        conn
        |> put_flash(:info, "Domain updated successfully.")
        |> redirect(to: domain_path(conn, :show, domain))
      {:error, changeset} ->
        render(conn, "edit.html", domain: domain, changeset: changeset)
    end
  end

  def delete_domain(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    domain = Repo.get!(Domain, id)
    Repo.delete!(domain)
    conn
    |> put_flash(:info, "Domain deleted successfully.")
    |> redirect(to: domain_path(conn, :edit_domains, user.id))
  end

  def delete(conn, %{"id" => id}) do
    domain = Repo.get!(Domain, id)
    IO.puts "Deleting"

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(domain)

    conn
    |> put_flash(:info, "Domain deleted successfully.")
    |> redirect(to: domain_path(conn, :index))
  end
end
