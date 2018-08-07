defmodule Cryptscrape.UserController do
  use Cryptscrape.Web, :controller

  import Cryptscrape.Authorize
  alias Phauxth.Log
  alias Cryptscrape.Accounts
  alias Cryptscrape.Payment

  # the following plugs are defined in the controllers/authorize.ex file
  plug :user_check when action in [:index, :show]
  plug :id_check when action in [:edit, :update, :delete]

  def index(conn, _) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def customers(conn, _) do
    full_list = Stripe.Customer.list()
    email = elem(full_list, 1).data |> Enum.map(fn(a) -> %{email: a.email} end)
    render(conn, "customers.html", email: email)
  end

  def charge(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
  changeset = Accounts.User.changeset(%Accounts.User{}, %{id: id})

  render(conn, "billing.html", changeset: changeset, user: user, id: id)
  end

  def success_charge(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do

  render(conn, "success_charge.html")
  end

  def create_charge(%Plug.Conn{assigns: %{current_user: user}} = conn,  _params) do

  data = conn.body_params
  email = data["stripeEmail"]
  card_token = data["stripeToken"]
  stripe_id = user.stripe_id
  Payment.create_customer(card_token, email, "Test Name 1", stripe_id)

  conn |> render("success_charge.html")
  end

  def new(conn, _) do
    changeset = Accounts.change_user(%Accounts.User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        Log.info(%Log{user: user.id, message: "user created"})
        success(conn, "User created successfully", session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def billing(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    render(conn, "billing.html")
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    user = (id == to_string(user.id) and user) || Accounts.get(id)

  

    render(conn, "show.html", user: user)
  end

  def edit(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"user" => user_params}) do
    IO.inspect user_params
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        success(conn, "User updated successfully", user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    {:ok, _user} = Accounts.delete_user(user)

    delete_session(conn, :phauxth_session_id)
    |> success("User deleted successfully", session_path(conn, :new))
  end
end
