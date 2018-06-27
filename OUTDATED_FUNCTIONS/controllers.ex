<td class="text-right">
  <span><%= link "Show", to: domain_path(@conn, :show, domain), class: "btn btn-default btn-xs" %></span>
  <span><%= link "Edit", to: domain_path(@conn, :edit, domain), class: "btn btn-default btn-xs" %></span>
  <span><%= link "Delete", to: domain_path(@conn, :delete, domain), method: :delete, data: [confirm: "Are you sure?"], class: "btn btn-danger btn-xs" %></span>
</td>
