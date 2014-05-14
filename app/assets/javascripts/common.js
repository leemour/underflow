$(function() {
  $('.question').on('click', '.edit', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    var question = $(this).closest('.question');
    var questionText = $(question).find('.question-text');
    questionText.hide();
    questionText = questionText.text().replace(/^\s{3,}|\s{3,}$/gm,'');
    $(question).find('.question-form textarea').val(questionText);
    $(question).find('.question-form').show();
  });

  $('.question').on('click', 'form .cancel', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    $('.question-text').show();
    $('.question-form').hide();
  });

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

  $("form").submit(function() {
    var button = $(":submit", this);
    var oldValue = button.val();
    button.val(button.attr('disable_with'));
    button.attr("disabled", true);
    setTimeout(function() {
      button.attr('disabled', false);
      button.val(oldValue);
    }, 3000)
  });
});