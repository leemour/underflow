require 'spec_helper'

feature 'User adds an answer',
%{
  In order to help question starter
  As a user
  I want to answer the question
  } do

  # context 'when logged in' do
  #   scenario 'answers with valid fields' do
  #     create(:user, email: '123@mail.ru', password: '12345678')
  #     sign_in_with('123@mail.ru', '12345678')

  #     visit questions_path
  #     click_on 'Задать вопрос'

  #     fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
  #     fill_in 'new-question-body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
  #     within("form") do
  #       click_on 'Задать вопрос'
  #     end

  #     expect(page).to have_content 'Вопрос успешно создан.'
  #   end

  #   scenario "can't answer with invalid fields" do
  #     create(:user, email: '123@mail.ru', password: '12345678')
  #     sign_in_with('123@mail.ru', '12345678')

  #     visit questions_path
  #     click_on 'Задать вопрос'

  #     fill_in 'Заголовок', with: 'Короткий'
  #     fill_in 'new-question-body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
  #     within("form") do
  #       click_on 'Задать вопрос'
  #     end

  #     expect(page).to have_content 'Заголовок недостаточной длины'
  #   end
  # end

  context 'when not logged in' do
    scenario "can't answer question" do
      question = create(:question)
      visit question_path(question)

      fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
      within("form#answer") do
        click_on 'Отправить ваш ответ'
      end

      expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
    end
  end
end