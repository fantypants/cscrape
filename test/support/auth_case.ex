defmodule CryptscrapeWeb.AuthCase do
  use Phoenix.ConnTest

  alias Cryptscrape.Accounts

  def add_user(email) do
    user = %{email: email, password: "reallyHard2gue$$"}
    {:ok, user} = Accounts.create_user(user)
    user
  end

  def add_phauxth_session(conn, user) do
    session_id = Phauxth.Login.gen_session_id("F")
    Accounts.add_session(user, session_id, System.system_time(:second))
    Phauxth.Login.add_session(conn, session_id, user.id)
  end

  def gen_key(email) do
    Phauxth.Token.sign(CryptscrapeWeb.Endpoint, %{"email" => email})
  end
end
