
legislatorsTemplate = "
  <% _.each(legislators, function (legislator) { %>
    <li>
      <label>
	<img src='http://www.govtrack.us/data/photos/<%= legislator.govtrack_id %>-50px.jpeg'/>
        <input name='legislators[]' value='<%= legislator.govtrack_id %>' type='checkbox' checked />
        <%= legislator.first_name %> <%= legislator.last_name %>
      </label>
    </li>
  <% }) %>
"

renderLegislators = (response) ->
  template = _.template legislatorsTemplate, legislators: response.results
  $(".legislators").html template

  if !response.results.length
    $(".signup").attr("data-state", "no-results")
  else
    $(".signup").attr("data-state", "loaded")

$(document).ready ->
  $(".find-legislators").submit (event) ->
    event.preventDefault()

    zip = $("input[name=zip]").val()
    $.getJSON "legislators/#{zip}", renderLegislators
    $(".signup").attr("data-state", "loading").show()

  $(".placeheld-field input").each ->
    input = $(this)

    input.attr "data-placeheld", !this.value.length
    input.on "change", -> input.attr('data-placeheld', !this.value.length)
