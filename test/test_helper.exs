#{:ok, _} = Application.ensure_all_started(:ex_machina)
ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Cryptscrape.Repo, :manual)

IO.puts "mix test"
