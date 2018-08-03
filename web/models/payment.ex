defmodule Cryptscrape.Payment do
  use Cryptscrape.Web, :controller
  alias Cryptscrape.Payment

@customer_api "https://api.stripe.com/v1/customers"
@subscription_api "https://api.stripe.com/v1/subscriptions"



stripe_key = Application.get_env(:cryptscrape, Cryptscrape.Endpoint)[:stripe_key]

@headers [{"Authorization", "Bearer #{stripe_key}"}, {"Content-Type", "application/x-www-form-urlencoded"}]


@spec create_customer(String.t, String.t, String.t) :: {:ok, map} | :fatal

def create_customer(cc_token, email, name) do
 url = "https://api.stripe.com/v1/customers"
 post(url, %{"source" => cc_token, "email" => email, "metadata[name]" => name})
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
            handle_event(event)
            send_resp(conn, 200, "Recieved Event Correctly")
          {:error, reason} ->
            send_resp(conn, 404, "")
  end
end

defp handle_event(event) do
  #Catch Payload
  #Determine Event
  #Submit Details
  case event do
    %Stripe.Event{} ->
      with {:ok, type} <- get_event(event) do
        case type do
          "charge.succeeded" ->
            IO.puts "Charge Succeeded"
          "charge.failed" ->
            IO.puts "Charge Failed"
          _->
            IO.puts "Other Event: #{type}"
        end
      end
    _->
      IO.puts "Error"
  end
end


defp get_event(data) do
  type = data.type
  account = data.account
  customer = data.data.object.id
  payload = %{type: type, customer: customer, account: account}
 {:ok, type}
end


























end
