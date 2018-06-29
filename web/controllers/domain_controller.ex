defmodule Cryptscrape.DomainController do
  use Cryptscrape.Web, :controller

  alias Cryptscrape.Domain

  def index(conn, _params) do
    domains = Repo.all(Domain) |> Enum.sort_by(fn(a) -> a.relevancy end) |> Enum.reverse
    #
    render(conn, "index.html", domains: domains)
  end


  def new(conn, _params) do
    changeset = Domain.changeset(%Domain{})
    render(conn, "new.html", changeset: changeset)
  end

  def run_list() do
    #Task.async(fn -> Cryptscrape.Scraper.runlist() end)
  end

  def add_vote(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id"=> domain_id}) do
    IO.puts "First stage of adding vote"
    IO.inspect user.id
    IO.inspect domain_id
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

  def delete(conn, %{"id" => id}) do
    domain = Repo.get!(Domain, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(domain)

    conn
    |> put_flash(:info, "Domain deleted successfully.")
    |> redirect(to: domain_path(conn, :index))
  end
end
