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

  feature 'edits question' do
    scenario 'with correct attributes' do
      click_on 'Редактировать'
      fill_in 'question_body',
        with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
      within("form") do
        click_on 'Задать вопрос'
      end
      expect(page).to have_content 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
    end

    scenario 'with incorrect attributes' do
      click_on 'Редактировать'
      fill_in 'question_body',
        with: ''
      within("form") do
        click_on 'Задать вопрос'
      end
      expect(page).to have_content 'Текст недостаточной длины'
    end
  end

  scenario 'deletes question' do
    click_on 'Удалить'
    expect(page).to have_content 'Вопрос успешно удален.'
  end
end