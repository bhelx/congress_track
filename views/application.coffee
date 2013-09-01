
legislatorsTemplate = "
  <ul>
    <% _.each(legislators, function (legislator) { %>
      <li>
        <%= legislator.first_name %> <%= legislator.last_name %>
        <input name='legislators[]' value='<%= legislator.govtrack_id %>' type='checkbox' checked></input>
      </li>
    <% }) %>
  </ul>
"

renderLegislators = (response) ->
  template = _.template legislatorsTemplate, legislators: response.results
  $('.legislators').html template

$(document).ready ->
  $("input[name=zip]").blur ->
    zip = $("input[name=zip]").val()
    $.getJSON "legislators/#{zip}", renderLegislators

