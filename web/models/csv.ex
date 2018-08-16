defmodule Cryptscrape.Csv do
  use Cryptscrape.Web, :controller
  use Timex
  alias Cryptscrape.DomainController
  alias Cryptscrape.Scraper
  alias Cryptscrape.Domain

def export(conn, _params) do
  task_params = Repo.all(Domain)
  task_name = "ALL_DOMAINS"
  conn
  |> put_resp_content_type("text/csv")
  |> put_resp_header("content-disposition", "attachment; filename=\"#{task_name}.csv\"")
  |> send_resp(200, csv_content())
end

defp csv_content do
  #task_params = Repo.all(from t in Task, where: t.id == ^task_id) |> List.first
  #task_name = Map.fetch!(task_params, :name) |> IO.inspect
  #task_url = Map.fetch!(task_params, :url)
  headers = [%{
    name: "Name",
    date: "Date",
    type: "Type",
    url: "Url",
    target: "Target",
    relevancy: "Relevancy"
    }]
  task_map = Repo.all(Domain) |> Enum.map(fn(a) -> %{
    name: a.name,
    date: a.date,
    type: a.type,
    url: a.url,
    target: a.target,
    relevancy: a.relevancy
    } end)
  export_map = headers ++ task_map |> IO.inspect
  csv_content = export_map
  |> Enum.map(fn(a) -> [a.name, a.date, a.type, a.url, a.target, a.relevancy] end)
  |> CSV.encode
  |> Enum.to_list
  |> to_string
end


def csvupload(conn, %{"id" => id}) do
  IO.puts "IN CSV"
  changeset = Domain.changeset(%Domain{})

  render(conn, "csvupload.html", changeset: changeset)
end

defp insert_csv(csv_map) do
  csv_map |> Enum.map(fn(row) -> insert_row(row) end)
end

defp insert_row(row) do
  changeset_params = row
  changeset = Domain.changeset(%Domain{}, changeset_params)
  Repo.insert!(changeset)
end
defp return_datetime(string) do
  string |> IO.inspect
    |> Timex.parse!("{ISO:Extended}")
    |> Ecto.DateTime.cast! |> Timex.to_naive_datetime()
end

defp process_csv(file) do
  csv = CSVLixir.read(file.path) |> Enum.to_list |> List.delete_at(0)
  csv_map = csv |> Enum.map(fn(a) -> %{
    name: elem(List.pop_at(a, 0),0),
    date: return_datetime(elem(List.pop_at(a, 1),0)),
    type: elem(List.pop_at(a, 2),0),
    url: elem(List.pop_at(a, 3),0),
    target: elem(List.pop_at(a, 4),0),
    relevancy: String.to_integer(elem(List.pop_at(a, 5),0))
  }end)

  Task.async(fn -> insert_csv(csv_map) end)
end

def insert(conn, params) do
  domain = params["domain"]
  if upload = domain["file"] do
     process_csv(upload)
  end
  changeset = Domain.changeset(%Domain{})

  render(conn, "upload.html", changeset: changeset)
end

end
