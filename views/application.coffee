
legislatorsTemplate = "
  <% _.each(legislators, function (legislator) { %>
    <li>
      <label class='select-legislator selected'>
        <img class='legislator-photo' src='http://www.govtrack.us/data/photos/<%= legislator.govtrack_id %>-50px.jpeg' alt='' />
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

  $("html, body").animate {scrollTop: $(document).height()} # deal with vertical SRE issues in a better way later

isValidZip = (zip) ->
  /(^\d{5}$)|(^\d{5}-\d{4}$)/.test(zip)

renderError = (message) ->
  $('.errors').html('<p>' + message + '</p>')

$(document).ready ->
  $(".legislators").on "change", ".select-legislator input[type='checkbox']", ->
    $(this).closest(".select-legislator").toggleClass "selected", $(this).prop("checked")

  $(".find-legislators").submit (event) ->
    event.preventDefault()

    zip = $("input[name=zip]").val()
    unless isValidZip(zip)
      renderError("Invalid ZIP code")
      return false

    $.getJSON "legislators/#{zip}", renderLegislators
    $(".signup").attr("data-state", "loading").show()

  $("form.signup").submit ->
    zip = $("#zip").val()
    $("#hidden_zip").val(zip)

  $(".placeheld-field input").each ->
    input = $(this)

    input.attr "data-placeheld", !this.value.length
    input.on "change", -> input.attr('data-placeheld', !this.value.length)
