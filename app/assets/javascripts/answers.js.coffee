# $ ->
#   $('#new_answer').on 'ajax:success', (e, data, status, xhr) ->
#     resp = $.parseJSON(xhr.responseText)
#     answer = HandlebarsTemplates['answers/answer'](resp);
#     $('#answers').append answer
#     $('time[data-time-ago]').timeago()
#     alert = HandlebarsTemplates['alert'](resp.alert)
#     $('#content').prepend(alert)
#     $('#answer-form #answer_body').val('');

#   .on 'ajax:error', (e, xhr, status, error) ->
#     errors = $.parseJSON(xhr.responseText)
#     errorList = $("<ul class='errors answer-errors'></ul>")
#     $.each errors, (i, value) ->
#       errorList.append "<li class='alert alert-danger'>" + value + "</li>"
#     $('.answer-errors').remove()
#     $('#new_answer').prepend errorList


#   $('.answer-edit-form form').on 'ajax:success', (e, data, status, xhr) ->
#     resp = $.parseJSON(xhr.responseText)
#     answer = $('#answer-'+resp.answer.id)
#     answer.find('.answer-text').text(resp.answer.body)
#     answer.css('background-color', '#eee')
#     uploads = answer.find('.answer-files')
#     uploads.html('')
#     $.each resp.attachments, (i, attach) ->
#       uploads.append(
#         '<li><a href="' + attach.url + '">' + attach.filename + '</a></li>')
#     Under.hideAllForms()
#     alert = HandlebarsTemplates['alert'](resp.alert)
#     $('#content').prepend(alert)

#   .on 'ajax:error', (e, xhr, status, error) ->
#     resp = $.parseJSON(xhr.responseText)
#     errorList = $("<ul class='errors answer-errors'></ul>")
#     $.each resp.errors, (i, value) ->
#       errorList.append "<li class='alert alert-danger'>" + value + "</li>"
#     $('.answer-errors').remove()
#     $('#answer-'+resp.id+' .answer-edit-form').prepend errorList