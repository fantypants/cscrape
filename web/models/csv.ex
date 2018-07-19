defmodule Cryptscrape.Csv do
  use Cryptscrape.Web, :controller
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

end
