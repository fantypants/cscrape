defmodule Cryptscrape.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Cryptscrape.Accounts.User

  schema "users" do
    field :email, :string
    field :stripe_id, :string
    field :paid, :boolean
    field :password, :string, virtual: true
    field :password_hash, :string
    field :sessions, {:map, :integer}, default: %{}
    field :auth_level, :boolean
    has_many :votes, Cryptscrape.Vote, on_delete: :nothing
    has_many :negvotes, Cryptscrape.Vote, on_delete: :nothing

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    paid = false
    #USED IN NORMAL FUNCTIONS & CHANGE PASSWORD
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
    |> unique_email
    |> cast_assoc(:votes)
    |> cast_assoc(:negvotes)
    |> validate_password(:password)
    |> put_pass_hash
  end

  def create_stripe_account(email) do
    request = Stripe.Customer.create(%{email: email}) |> IO.inspect
      case request do
       {:ok, data} ->
        details = %{email: data.email, id: data.id}
       {:error, data} ->
          IO.inspect data
        IO.puts "Stripe Did Not Work"
        details = %{email: email, id: "did not work"}
      end
      details
  end

  def create_changeset(%User{} = user, attrs) do
    IO.puts "THis changeset is when creating a user"
    paid = false
    stripe = create_stripe_account(attrs["email"])
    attrs = Map.merge(attrs, %{"paid" => paid, "stripe_id" => stripe.id})
    user
    |> cast(attrs, [:email, :password, :paid, :stripe_id, :auth_level])
    |> cast_assoc(:votes)
    |> validate_required([:email, :password, :paid, :stripe_id, :auth_level])
    |> unique_email
    |> validate_password(:password)
    |> put_pass_hash
  end

  defp unique_email(changeset) do
    validate_format(changeset, :email, ~r/@/)
    |> validate_length(:email, max: 254)
    |> unique_constraint(:email)
  end

  # In the function below, strong_password? just checks that the password
  # is at least 8 characters long.
  # See the documentation for NotQwerty123.PasswordStrength.strong_password?
  # for a more comprehensive password strength checker.
  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case strong_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  # If you are using Argon2 or Pbkdf2, change Bcrypt to Argon2 or Pbkdf2
  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
      %{password: password}} = changeset) do
    change(changeset, Comeonin.Bcrypt.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp strong_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  defp strong_password?(_), do: {:error, "The password is too short"}

  def check_user(email) do
    exists? = Cryptscrape.Repo.all(from u in User, where: u.email == ^email)
    case exists? do
      nil ->
        {:error, "User Doesn't Exist"}
      _->
      {:ok, exists?}
    end
  end

 def retrieve_password do
   password_new = random_string(8)
   {:ok, password_new}
 end

 def random_string(length) do
  :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
end
end
