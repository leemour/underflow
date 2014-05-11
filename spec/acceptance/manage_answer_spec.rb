require 'spec_helper'

feature 'User manages an answer',
%{
  In order to add or remove details
  As a user
  I want to manage answer
  } do

  given!(:user)     { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer)   { create(:answer, question: question, user: user) }

  background do
    sign_in_with(user.email, user.password)
    visit question_path(question)
  end

  feature 'edits answer' do
    scenario 'with correct text' do
      within("#answer-#{answer.id}") do
        click_on 'Редактировать'
      end
      fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
      click_on 'Отправить ваш ответ'

      expect(page).to have_content 'Ответ успешно обновлен.'
    end

    scenario 'with incorrect text' do
      within("#answer-#{answer.id}") do
        click_on 'Редактировать'
      end
      fill_in 'answer_body', with: ''
      click_on 'Отправить ваш ответ'

      expect(page).to have_content 'Текст недостаточной длины'
    end
  end

  scenario "deletes answer" do
    within("#answer-#{answer.id}") do
      click_on 'Удалить'
    end

    expect(page).to have_content 'Ответ успешно удален.'
  end
end