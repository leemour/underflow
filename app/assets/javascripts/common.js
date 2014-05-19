$(function() {
  $("form").find(':submit').attr('disabled', false);

  $('.question').on('click', '.edit', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    var question = $(this).closest('.question');
    var questionTitle = $(question).find('h1').text();
    var questionText = $(question).find('.question-text');
    questionText = questionText.text().replace(/^\s{3,}|\s{3,}$/gm,'');
    $(question).find('.question-edit-form #question_title').val(questionTitle);
    $(question).find('.question-edit-form textarea').val(questionText);
    $(question).find('.question-body').hide();
    $(question).find('.controls').hide();
    $(question).find('.question-errors').hide();
    $(question).find('.question-edit-form').show();
  });

  $('.question').on('click', 'form .cancel', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    $('.question-body').show();
    $('.controls').show();
    $('.question-edit-form').hide();
  });

  $('#answers').on('click', '.answer .edit', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    $('.answer-body').show();
    $('.controls').show();
    $('.answer-edit-form').hide();
    var answerId = $(this).data('answer-id')
    var answer = $('#answer-' + answerId);
    var answerText = $(answer).find('.answer-text');
    $(answer).find('.answer-edit-form textarea').val(answerText.text());
    $(answer).find('.answer-body').hide();
    $(answer).find('.controls').hide();
    $(answer).find('.answer-errors').hide();
    $(answer).find('.answer-edit-form').show();
  });

  $('#answers').on('click', '.answer form .cancel', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    $('.answer-body').show();
    $('.controls').show();
    $('.answer-edit-form').hide();
  });

  $("form").submit(function() {
    var button = $(":submit", this);
    var oldValue = button.val();
    button.val(button.data('disable_with'));
    button.attr("disabled", true);
    setTimeout(function() {
      button.attr('disabled', false);
      button.val(oldValue);
    }, 3000)
  });
});