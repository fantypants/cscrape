defmodule Cryptscrape.Payment do
  use Cryptscrape.Web, :controller
  alias Cryptscrape.Payment
  alias Cryptscrape.Accounts.User

@customer_api "https://api.stripe.com/v1/customers"
@subscription_api "https://api.stripe.com/v1/subscriptions"



stripe_key = Application.get_env(:cryptscrape, Cryptscrape.Endpoint)[:stripe_key]

@headers [{"Authorization", "Bearer #{stripe_key}"}, {"Content-Type", "application/x-www-form-urlencoded"}]


@spec create_customer(String.t, String.t, String.t, String.t) :: {:ok, map} | :fatal

def create_customer(cc_token, email, name, stripe_id) do
 url = "https://api.stripe.com/v1/customers"
 #post(url, %{"source" => cc_token, "email" => email, "metadata[name]" => name})
 plan_id = "plan_DLuOXRMspS7po7"
 subscription = create_subscription(cc_token, email, name, stripe_id, plan_id)
 paid? = subscription["items"]["data"] |> Enum.map(fn(a) -> IO.inspect a end)
 #MAke plan
 #Sign USer
 #Get return
 #Get user details
 #Update DB with returned outcome

end

defp create_subscription(cc_token, email, name, stripe_id, plan_id) do
  url = "https://api.stripe.com/v1/subscriptions"
  post(url, %{"source" => cc_token, "customer" => stripe_id, "items[0][plan]" => plan_id})
  #Catch Subscription -> Check Return -> Update DB
end

def check_plan(customer_id) do
  Stripe.Customer.retrieve(customer_id) |> IO.inspect
end


@spec post(iodata, map) :: {:ok, map} | :fatal

defp post(url, body) do
 #request(:post, [encode_url(url), URI.encode_query(body), @headers])
 request = HTTPoison.post(url, URI.encode_query(body), @headers, [])
 case request do
   {:ok, data} -> Poison.decode!(data.body)
   {:error, data} -> IO.puts "Error Occured"
 end
end



@spec request(atom, [any]) :: {:ok, map} | :fatal

defp request(method, args) do
 case apply(@http, method, args) do
   {:ok, %{status_code: 200, body: body}} -> {:ok, Jason.decode!(body)}
   err ->
     IO.puts "Error Occured with Stripe"
     :fatal
 end
end



defp encode_url(url) do
 url
   |> :erlang.iolist_to_binary()
   |> URI.encode()
end

def read_body(conn, opts) do
  IO.puts "READ BODY PLUG"
   {:ok, body, conn} = Plug.Conn.read_body(conn, opts)
   conn = update_in(conn.assigns[:raw_body], &[body | (&1 || [])])
   {:ok, body, conn}
 end


def webhook(conn, params) do
  payload = conn.assigns[:raw_body]
  signature = Plug.Conn.get_req_header(conn, "stripe-signature") |> List.first
  secret = Application.get_env(:cryptscrape, Cryptscrape.Endpoint)[:webhook_key]
  case Stripe.Webhook.construct_event(payload, signature, secret) do
          {:ok, %Stripe.Event{} = event} ->
            IO.puts "Handling Authorized Stripe Event"
            handle_event(conn, event)
            send_resp(conn, 200, "Recieved Event Correctly")
          {:error, reason} ->
            send_resp(conn, 404, "")
  end
end

defp handle_event(conn, event) do
  #Catch Payload
  #Determine Event
  #Submit Details
  case event do
    %Stripe.Event{} ->
      with {:ok, type} <- get_event(event) do
        case type do
          "charge.succeeded" ->
            IO.puts "Charge Succeeded is Frist step in Payment Process"
            with {:ok, customer} <- get_customer(event) do
              reflect_payment(customer, true)
            end
          "charge.failed" ->
            IO.puts "Charge Failed"
            with {:ok, customer} <- get_customer(event) do
              reflect_payment(customer, false)
            end
          "create.charge" ->
            IO.puts "charge Created"
          "subscription.plan.succeeded" ->
            IO.puts "Subscription Plan Created"
          "subscription.plan.cancelled" ->
            IO.puts "Subscription Plan Cancelled"
          "invoice.payment_succeeded" ->
            IO.puts "Second Step in Subscription Process"
          _->
            IO.puts "Other Event: #{type}"
        end
      end
    _->
      IO.puts "Error"
  end
end


defp reflect_payment(customer, value) do
  case value do
    true ->
      IO.puts "Update profile for reflected payment"
      with {:ok, user_id} <- convert_customer(customer) do
        update_user(user_id, value)
      end
    false ->
      IO.puts "Payment Declined"
      with {:ok, user_id} <- convert_customer(customer) do
        update_user(user_id, value)
      end
  end
end

defp update_user(id, value) do
  user = Repo.get!(User, id)
  case user do
    nil ->
      {:error, "User Not Found"}
    _->
    user = Ecto.Changeset.change user, paid: value
    case Repo.update user do
      {:ok, struct}       -> IO.puts "Success, Customer Updated"
      {:error, changeset} -> IO.puts "Incorrect, Customer Not Updated"
    end
  end

end

defp convert_customer(customer) do
  IO.inspect customer
  #customer_id = elem(customer, 1) |> IO.inspect
  user_id = Repo.all(from u in User, where: u.stripe_id == ^customer, select: u.id) |> List.first
  case user_id do
    nil ->
      {:error, "No User Found"}
      _->
      {:ok, user_id}
  end

end

defp get_customer(data) do
source = data.data.object.source
customer = source.customer
{:ok, customer}
end

defp get_event(data) do
  type = data.type
 {:ok, type}
end


























end
