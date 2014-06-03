$ ->
  $('.favor').on 'ajax:success', (e, data, status, xhr) ->
    resp = $.parseJSON(xhr.responseText)
    if resp.favored
      $(resp.selector + ' .favor').addClass('favored')
    else
      $(resp.selector + ' .favor').removeClass('favored')
    $(resp.selector + ' .favor .text').text(resp.text)