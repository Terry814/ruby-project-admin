<% if @social_links.any? %>
$('#quick-start-wizard').steps 'insert', 1,
  title: 'Social Links.'
  content: $("<%=j render 'social_links_form' %>").find '#step-content'
<% end %>

<% if @web_links.any? %>
$('#quick-start-wizard').steps 'insert', 1,
  title: 'Web Links.'
  content: $("<%=j render 'links_form' %>").find '#step-content'
<% end %>

$('#quick-start-wizard').steps 'next'