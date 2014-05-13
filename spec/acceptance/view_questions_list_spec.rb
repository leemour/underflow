require_relative '../acceptance_helper'

feature 'User views list of questions',
%{
  In order to answer questions
  As a user
  I want to see a list of questions
  } do

  scenario 'on homepage ordered by date' do
    question1 = create(:question, title: 'Тестовый вопрос номер 1')
    question2 = create(:question, title: 'Тестовый вопрос номер 2')

    visit '/'

    expect(question1.title).to appear_before(question2.title)
  end
end