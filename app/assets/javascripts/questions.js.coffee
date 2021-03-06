$ ->
  $('.favor').on 'ajax:success', (e, data, status, xhr) ->
    resp = $.parseJSON(xhr.responseText)
    if resp.favored
      $(resp.selector + ' .favor').addClass('favored')
    else
      $(resp.selector + ' .favor').removeClass('favored')
    $(resp.selector + ' .favor .text').text(resp.text)
    $(resp.selector + ' .favor').attr('title', resp.text)


  $(document).on 'ajax:error', (e, xhr, status, error) ->
    resp = $.parseJSON(xhr.responseText)
    $('#content').prepend(
      '<div class="alert alert-danger">' +
        '<a class="close" data-dismiss="alert">×</a>' +
        '<div class="flash-error">'+resp.message+'</div>' +
      '</div>'
    )