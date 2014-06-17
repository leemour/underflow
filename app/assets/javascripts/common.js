$(function() {
  Under = {
    // Show edit forms
    showQuestionForm: function(link) {
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
    ,
    showAnswerForm: function(link) {
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
    ,
    showCommentForm: function(link) {
      var comment = $(link).closest('.comment');
      var commentBody = $(comment).find('.comment-body');
      var commentText = commentBody.text().replace(/^\s{3,}|\s{3,}$/gm,'');
      $(comment).find('.comment-edit-form textarea').val(commentText);
      commentBody.hide();
      $(comment).find('.controls').hide();
      $(comment).find('.comment-errors').hide();
      $(comment).find('.comment-edit-form').show();
    }
    ,
    // Show new comment forms
    showQuestionCommentForm: function(link) {
      var question = $(link).closest('.question');
      $(question).find('.comment-create-form').show();
      $(link).hide();
      $(question).find('.comment-errors').hide();
      $(question).find('.comment-edit-form').hide();
    }
    ,
    showAnswerCommentForm: function(link) {
      var answer = $(link).closest('.answer');
      $(answer).find('.comment-create-form').show();
      $(link).hide();
      $(answer).find('.comment-errors').hide();
      $(answer).find('.comment-edit-form').hide();
    }
    ,
    showNewCommentForm: function(object, link) {
      var objectId = $(link).closest('.'+object).attr('id').split('-')[1];
      $('#new_comment').insertAfter('#'+object+'-'+objectId+' .comments').show();
      $('#new_comment').attr('action', '/'+object+'s/'+objectId+'/comments')
      $(link).hide();
      $('.comment-create-form').find('.comment-errors').hide();
    }
    ,
    // Show bount form
    showBountyForm: function(link) {
      $('.start-bounty').hide()
      $('#new_bounty').show()
    }
    ,
    // Hide edit forms
    hideQuestionForm: function() {
      $('.question-body').show();
      $('.controls').show();
      $('.question-edit-form').hide();
    }
    ,
    hideAnswerForm: function() {
      $('.answer-body').show();
      $('.controls').show();
      $('.answer-edit-form').hide();
    }
    ,
    hideCommentForm: function() {
      $('.comment-body').show();
      $('.add-comment').show();
      // $('.comment-create-form').hide();
      $('.comment-edit-form').hide();
      $('#new_comment').hide();
      $('#new_comment .errors').hide();
    }
    ,
    hideBountyForm: function() {
      $('.start-bounty').show()
      $('#new_bounty').hide()
    }
    ,
    hideAllForms: function() {
      Under.hideQuestionForm();
      Under.hideAnswerForm();
      Under.hideCommentForm();
      Under.hideBountyForm();
    }
    ,
    // Add extra file input field
    addFileInput: function(link, container) {
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
  }


  // Edit links
  $('.question').on('click', '.question-details .edit', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.hideAnswerForm();
    Under.hideCommentForm();
    Under.showQuestionForm(this);
  });

  $('#answers').on('click', '.answer-details .edit', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.hideAllForms();
    Under.showAnswerForm(this);
  });

  $('.comments').on('click', '.edit', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.hideAllForms();
    Under.showCommentForm(this);
  });

  // Cancel buttons
  $('.question').on('click', '.cancel', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.hideAllForms();
  });

  $('#answers').on('click', '.answer .cancel', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.hideAllForms();
  });

  // Add comment links
  $('.question').on('click', '.add-comment', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.hideAllForms();
    Under.showNewCommentForm('question', this);
  });

  $('#answers').on('click', '.add-comment', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.hideAllForms();
    Under.showNewCommentForm('answer', this);
  });

  // Add file links
  $('.question').on('click', '.add-file', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.addFileInput(this, '.question')
  });

  $('#answers').on('click', '.answer .add-file', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.addFileInput(this, '.answer')
  });

  $('#answer-form').on('click', '.add-file', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.addFileInput(this, '#answer-form')
  });

  // Add bounty link
  $('.question').on('click', '.start-bounty', function(ev) {
    ev.preventDefault(); ev.stopPropagation();
    Under.hideAllForms();
    Under.showBountyForm();
  });

  $('.login-link').hide();
  $('.login-link.js').show();
});