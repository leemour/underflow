$('#answers').on('click', '.answer .edit', function(ev) {
  ev.preventDefault(); ev.stopPropagation();
  $('.answer-text').show();
  $('.answer-form').hide();
  var answer = $(this).closest('.answer');
  var answerText = $(answer).find('.answer-text');
  answerText.hide();
  $(answer).find('.answer-form textarea').val(answerText.text());
  $(answer).find('.answer-form').show();
});

$('#answers').on('click', '.answer form .cancel', function(ev) {
  ev.preventDefault(); ev.stopPropagation();
  $('.answer-text').show();
  $('.answer-form').hide();
});
