$ ->
  # Vote links
  $('.upvote, .downvote').on 'ajax:success', (e, data, status, xhr) ->
    resp = $.parseJSON(xhr.responseText)
    $(resp.selector + ' .vote-sum').text(resp.sum)

    if resp.voted
      $(resp.selector + ' ' + resp.action).addClass('voted')
      $(resp.selector + ' ' + resp.other_action).removeClass('voted')
    else
      $(resp.selector + ' ' + resp.action).removeClass('voted')
      $(resp.selector + ' ' + resp.other_action).removeClass('voted')

    $(resp.selector + ' ' + resp.action + ' .text').text(resp.text)
    $(resp.selector + ' ' + resp.other_action + ' .text').text(resp.other_text)
    $(resp.selector + ' ' + resp.action).attr('title', resp.text)
    $(resp.selector + ' ' + resp.other_action).attr('title', resp.other_text)