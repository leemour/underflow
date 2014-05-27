$('#new_answer').on 'ajax:success', (e, data, status, xhr) ->
  answer = $.parseJSON(xhr.responseText)
  alert(answer.body)
  $('#answers').append "<div class='answer'>" + answer.body + '</div>'
.on 'ajax:error', (e, xhr, status, error) ->
  errors = $.parseJSON(xhr.responseText)
  errorList = $("<ul class='errors answer-errors'></ul>")
  $.each errors, (i, value) ->
    errorList.append "<li class='alert alert-danger'>" + value + "</li>"
  $('.answer-errors').remove()
  $('#new_answer').prepend errorList
  $('.answer-errors').show()