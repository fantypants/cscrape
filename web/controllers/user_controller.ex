defmodule Cryptscrape.UserController do
  use Cryptscrape.Web, :controller

  import Cryptscrape.Authorize
  alias Phauxth.Log
  alias Cryptscrape.Accounts
  alias Cryptscrape.Payment
  alias Cryptscrape.Mailer
  alias Bamboo.SentEmailViewerPlug

  # the following plugs are defined in the controllers/authorize.ex file
  plug :user_check when action in [:index, :show]
  plug :id_check when action in [:edit, :update, :delete]

  def index(conn, _) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def admin(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    render(conn, "admin.html", user: user)
  end

  def view_emails(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
  changeset = Accounts.User.changeset(%Accounts.User{}, %{name: "name"})
  emails = Bamboo.SentEmail.all |> Enum.map(fn(a) -> %{from: elem(a.from, 1), to: elem(List.first(a.to), 1), subject: a.subject, message: a.html_body} end)
  render(conn, "viewemails.html", changeset: changeset, emails: emails)
  end

  def reset_password(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
    changeset = Accounts.User.changeset(%Accounts.User{}, %{name: "name"})
    render(conn, "resetpassword.html", changeset: changeset)
  end

def passwordreset(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"user" => %{"email" => email}}) do
changeset = Accounts.User.changeset(%Accounts.User{}, %{name: "name"})
  case Accounts.User.check_user(email) do
    {:ok, user} ->
      case Accounts.User.retrieve_password do
        {:ok, password} ->
          case Accounts.update_user(List.first(user), %{"email" => email, "password" => password}) do
            {:ok, user} ->
              Cryptscrape.Email.password_recovery(email, password) |> Cryptscrape.Mailer.deliver_now
              render(conn, "resetpassword.html", changeset: changeset)
            {:error, %Ecto.Changeset{} = changeset} ->
              IO.puts "Didn't Work"
              IO.inspect changeset
              render(conn, "resetpassword.html", changeset: changeset)
          end
        {:error, message} ->
          IO.puts "Password Change Failed"
          render(conn, "resetpassword.html", changeset: changeset)
        end
    {:error, message} ->
        render(conn, "resetpassword.html", changeset: changeset)
    end
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
    email = user_params["email"]
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        Log.info(%Log{user: user.id, message: "user created"})
        Cryptscrape.Email.welcome_email(email) |> Cryptscrape.Mailer.deliver_now
        success(conn, "User created successfully", session_path(conn, :new))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def billing(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    render(conn, "billing.html")
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    user = (id == to_string(user.id) and user) || Accounts.get(id) |> IO.inspect
    Repo.get!(Accounts.User, id) |> IO.inspect


    render(conn, "show.html", user: user)
  end

  def edit(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"user" => user_params}) do
    IO.inspect user_params
    IO.puts "Working with password changeset"
    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        IO.inspect user
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
