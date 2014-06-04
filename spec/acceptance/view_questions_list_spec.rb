require_relative '../acceptance_helper'

feature 'User views list of questions',
%{
  In order to answer questions
  As a user
  I want to see a list of questions
  } do

  context 'All questions' do
    scenario 'ordered by date newest first' do
      question1 = create(:question, title: 'Тестовый вопрос номер 1')
      question2 = create(:question, title: 'Тестовый вопрос номер 2')

      visit root_path

      expect(question2.title).to appear_before(question1.title)
    end
  end

  context 'Unanswered questions' do
    # scenario 'ordered by date newest first' do
    #   question1 = create(:question, title: 'Тестовый вопрос номер 1')
    #   question2 = create(:question, title: 'Тестовый вопрос номер 2')

    #   visit unanswered_questions_path

    #   expect(question2.title).to appear_before(question1.title)
    # end
  end
end