<td class="text-right">
  <span><%= link "Show", to: domain_path(@conn, :show, domain), class: "btn btn-default btn-xs" %></span>
  <span><%= link "Edit", to: domain_path(@conn, :edit, domain), class: "btn btn-default btn-xs" %></span>
  <span><%= link "Delete", to: domain_path(@conn, :delete, domain), method: :delete, data: [confirm: "Are you sure?"], class: "btn btn-danger btn-xs" %></span>
</td>


<%= for vote <- domain.votes do %>
<td><%= vote.value %></td>
<% end %>


<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootswatch/4.1.1/lux/bootstrap.min.css">


def create_charge(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"params" => params}) do
changeset = Accounts.User.changeset(%Accounts.User{}, %{id: id})
  params = %{
    amount: 1,
    card: users["card"],
    currency: "USD",
    customer: user.stripe_id
  }

IO.puts "User Strip ID"
IO.inspect user.stripe_id
request = Stripe.Charge.create(params) |> IO.inspect
render(conn, "success_charge.html")
  #case request do
#    {:ok, data} ->
  #  details = %{email: data.email, id: data.id}
#    render(conn, "success_charge.html")
#    {:error, data} ->
#    render(conn, "billing.html", changeset: changeset, user: user)
#  end
end
