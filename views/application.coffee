
legislatorsTemplate = "
  <% _.each(legislators, function (legislator) { %>
    <li>
      <label>
        <input name='legislators[]' value='<%= legislator.govtrack_id %>' type='checkbox' checked />
        <%= legislator.first_name %> <%= legislator.last_name %>
      </label>
    </li>
  <% }) %>
"

renderLegislators = (response) ->
  template = _.template legislatorsTemplate, legislators: response.results
  $('.legislators').html template
  $('.signup').show()

$(document).ready ->
  $(".find-legislators").submit (event) ->
    event.preventDefault()

    zip = $("input[name=zip]").val()
    $.getJSON "legislators/#{zip}", renderLegislators

  $(".placeheld-field input").each ->
    input = $(this)

    input.attr "data-placeheld", !this.value.length
    input.on "change", -> input.attr('data-placeheld', !this.value.length)
