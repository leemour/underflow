require 'spec_helper'

feature 'User views a question',
%{
  In order to answer questions
  As a user
  I want to see full question
  } do

  given(:question) { create(:question) }

  scenario 'with title and body' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end