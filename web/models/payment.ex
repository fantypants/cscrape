defmodule Cryptscrape.Payment do
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
end
