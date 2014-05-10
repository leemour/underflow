require 'spec_helper'

feature 'User manages his question',
%{
  In order to change details
  As a user
  I want to edit or delete my own question
  } do

    background do
      user = create(:user)
      sign_in_with(user.email, user.password)
      question = create(:question, user: user)
      visit question_path(question)
    end

    scenario 'edits question' do
      click_on 'Редактировать'
      fill_in 'question_body',
        with: 'Это не коварный вопрос. Это не коварный вопрос. Это не коварный вопрос. '
      within("form") do
        click_on 'Задать вопрос'
      end
      expect(page).to have_content 'Это не коварный вопрос. Это не коварный вопрос. Это не коварный вопрос. '
    end

    it 'deletes question' do
      click_on 'Удалить'
    end
  end