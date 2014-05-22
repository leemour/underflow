$(function() {
  // AJAX form submit enable
  $("form").find(':submit').attr('disabled', false);

  // AJAX form submit disable
  $("form").submit(function() {
    var button = $(":submit", this);
    var oldValue = button.val();
    button.val(button.data('disable_with'));
    button.attr("disabled", true);
    setTimeout(function() {
      button.attr('disabled', false);
      button.val(oldValue);
    }, 3000);
  });

  // Show edit forms
  function showQuestionForm(link) {
    var question = $(link).closest('.question');
    var questionTitle = $(question).find('h1').text();
    var questionText = $(question).find('.question-text');
    questionText = questionText.text().replace(/^\s{3,}|\s{3,}$/gm,'');
    $(question).find('.question-edit-form #question_title').val(questionTitle);
    $(question).find('.question-edit-form textarea').val(questionText);
    $(question).find('.question-body').hide();
    $(question).find('.question .controls').hide();
    $('.comments .controls').show();
    $(question).find('.question-errors').hide();
    $(question).find('.question-edit-form').show();
  }

  function showAnswerForm(link) {
    $('.answer-body').show();
    $('.controls').show();
    $('.answer-edit-form').hide();
    var answerId = $(link).data('answer-id');
    var answer = $('#answer-' + answerId);
    var answerText = $(answer).find('.answer-text');
    $(answer).find('.answer-edit-form textarea').val(answerText.text());
    $(answer).find('.answer-body').hide();
    $(answer).find('.answer-details .controls').hide();
    $(answer).find('.answer-errors').hide();
    $(answer).find('.answer-edit-form').show();
  }

  function showCommentForm(link) {
    var comment = $(link).closest('.comment');
    var commentBody = $(comment).find('.comment-body');
    var commentText = commentBody.text().replace(/^\s{3,}|\s{3,}$/gm,'');
    $(comment).find('.comment-edit-form textarea').val(commentText);
    commentBody.hide();
    $(comment).find('.controls').hide();
    $(comment).find('.comment-errors').hide();
    $(comment).find('.comment-edit-form').show();
  }

  // Show new comment forms
  function showQuestionCommentForm(link) {
    var question = $(link).closest('.question');
    $(question).find('.comment-create-form').show();
    $(link).hide();
    $(question).find('.comment-errors').hide();
    $(question).find('.comment-edit-form').hide();
  }

  function showAnswerCommentForm(link) {
    var answer = $(link).closest('.answer');
    $(answer).find('.comment-create-form').show();
    $(link).hide();
    $(answer).find('.comment-errors').hide();
    $(answer).find('.comment-edit-form').hide();
  }

  // Hide edit forms
  function hideQuestionForm() {
    $('.question-body').show();
    $('.controls').show();
    $('.question-edit-form').hide();
  }

  function hideAnswerForm() {
    $('.answer-body').show();
    $('.controls').show();
    $('.answer-edit-form').hide();
  }

  function hideCommentForm() {
    $('.comment-body').show();
    $('.add-comment').show();
    $('.comment-create-form').hide();
    $('.comment-edit-form').hide();
  }

  // Add extra file input field
  function addFileInput(link, container) {
    var upload = $(link).closest(container).find('.file-upload').last().clone();
    var count = upload.html().match(/attributes\]\[(\d+)\]/)[1];
    count++;
    upload.html(
      upload.html()
      .replace(/attributes\]\[\d+\]/mg, 'attributes]['+count+']')
      .replace(/attributes_\d+/mg, 'attributes_'+count)
    );
    upload.insertBefore($(link));
  }

  // Edit links
  $('.question').on('click', '.question-details .edit', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    hideAnswerForm();
    hideCommentForm();
    showQuestionForm(this);
  });

  $('#answers').on('click', '.answer-details .edit', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    hideQuestionForm();
    hideAnswerForm();
    hideCommentForm();
    showAnswerForm(this);
  });

  $('.comments').on('click', '.edit', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    hideQuestionForm();
    hideAnswerForm();
    hideCommentForm();
    showCommentForm(this);
  });

  // Cancel buttons
  $('.question').on('click', '.cancel', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    hideQuestionForm();
    hideAnswerForm();
    hideCommentForm();
  });

  $('#answers').on('click', '.answer .cancel', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    hideQuestionForm();
    hideAnswerForm();
    hideCommentForm();
  });

  // Add comment links
  $('.question').on('click', '.add-comment', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    hideQuestionForm();
    hideAnswerForm();
    hideCommentForm();
    showQuestionCommentForm(this);
  });

  $('#answers').on('click', '.add-comment', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    hideQuestionForm();
    hideAnswerForm();
    hideCommentForm();
    showAnswerCommentForm(this);
  });

  // Add file links
  $('.question').on('click', '.add-file', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    addFileInput(this, '.question')
  });

  $('#answers').on('click', '.answer .add-file', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    addFileInput(this, '.answer')
  });
});