%{"account_balance" => 0, "created" => 1533092213, "currency" => nil,
  "default_source" => "card_1CuAW1J1Re7kKO1MzzVdrdj1", "delinquent" => false,
  "description" => nil, "discount" => nil, "email" => "stripetest2@gmail.com",
  "id" => "cus_DKqCFHfDwQpGOO", "invoice_prefix" => "601DE2A",
  "livemode" => false, "metadata" => %{"name" => "Test Name 1"},
  "object" => "customer", "shipping" => nil,
  "sources" => %{
    "data" => [%{
      "address_city" => nil,
      "address_country" => nil,
       "address_line1" => nil,
       "address_line1_check" => nil,
       "address_line2" => nil,
       "address_state" => nil,
       "address_zip" => "94612",
       "address_zip_check" => "pass",
       "brand" => "Visa", "country" => "US",
       "customer" => "cus_DKqCFHfDwQpGOO",
       "cvc_check" => "pass",
       "dynamic_last4" => nil,
       "exp_month" => 1,
       "exp_year" => 2019,
       "fingerprint" => "qO9nK3Pu4g9CQvPR",
       "funding" => "credit",
       "id" => "card_1CuAW1J1Re7kKO1MzzVdrdj1",
       "last4" => "0077",
       "metadata" => %{},
       "name" => "stripetest2@gmail.com",
       "object" => "card",
       "tokenization_method" => nil}],
       "has_more" => false,
       "object" => "list",
    "total_count" => 1, "url" => "/v1/customers/cus_DKqCFHfDwQpGOO/sources"},
  "subscriptions" => %{"data" => [], "has_more" => false, "object" => "list",
    "total_count" => 0,
    "url" => "/v1/customers/cus_DKqCFHfDwQpGOO/subscriptions"}}


    Parameters: %{
      "api_version" => "2018-05-21",
      "created" => 1326853478,
      "data" => %{
        "object" => %{
          "id" => "ca_00000000000000",
          "name" => nil,
          "object" =>
          "application"}
          },
          "id" => "evt_00000000000000",
          "livemode" => false,
          "object" => "event",
          "pending_webhooks" => 1,
          "request" => nil,
          "type" => "account.application.authorized"}





  # Charge Succeeded
  Parameters: %{
    "api_version" => "2018-05-21",
    "created" => 1533585886,
    "data" => %{
      "object" => %{
        "source" => %{
          "address_city" => nil,
          "address_country" => nil,
          "address_line1" => nil,
          address_line1_check" => nil,
          "address_line2" => nil,
          "address_state" => nil,
          "address_zip" => nil, 
          "address_zip_check" => nil,
          "brand" => "Visa",
          "country" => "US",
          "customer" => "cus_DKq78OmisxKKQl",
          "cvc_check" => "pass",
          "dynamic_last4" => nil,
          "exp_month" => 1,
          "exp_year" => 2019,
          "fingerprint" => "qO9nK3Pu4g9CQvPR",
          "funding" => "credit",
          "id" => "card_1CwEwQJ1Re7kKO1Mvfq8ziCk",
          "last4" => "0077", "metadata" => %{},
          "name" => "stripetest2@gmail.com",
          "object" => "card", "tokenization_method" => nil}, "on_behalf_of" => nil, "application" => nil, "customer" => "cus_DKq78OmisxKKQl", "balance_transaction" => "txn_1CwEwaJ1Re7kKO1McGCtiJ7v", "review" => nil, "created" => 1533585884, "statement_descriptor" => nil, "source_transfer" => nil, "amount" => 999, "transfer_group" => nil, "captured" => true, "outcome" => %{"network_status" => "approved_by_network", "reason" => nil, "risk_level" => "normal", "seller_message" => "Payment complete.", "type" => "authorized"}, "id" => "ch_1CwEwaJ1Re7kKO1Mhzxzn1l3", "amount_refunded" => 0, "receipt_number" => nil, "currency" => "usd", "refunds" => %{"data" => [], "has_more" => false, "object" => "list", "total_count" => 0, "url" => "/v1/charges/ch_1CwEwaJ1Re7kKO1Mhzxzn1l3/refunds"}, "paid" => true, "application_fee" => nil, "failure_code" => nil, "failure_message" => nil, "invoice" => "in_1CwEwaJ1Re7kKO1Mah1fKgrG", "shipping" => nil, "status" => "succeeded", "refunded" => false, "fraud_details" => %{}, "description" => nil, "metadata" => %{}, "livemode" => false, "object" => "charge", "dispute" => nil, "order" => nil, "destination" => nil, "receipt_email" => nil}}, "id" => "evt_1CwEwcJ1Re7kKO1MTrBV61zH", "livemode" => false, "object" => "event", "pending_webhooks" => 1, "request" => %{"id" => "req_s7eA9qJZgiGJUw", "idempotency_key" => nil}, "type" => "charge.succeeded"}
