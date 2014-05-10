require 'spec_helper'

feature 'User adds an answer',
%{
  In order to help question starter
  As a user
  I want to answer the question
  } do

  context 'when logged in' do
    background do
      user = create(:user)
      sign_in_with(user.email, user.password)


      # queston = create(:question)
      question = user.questions.create(attributes_for(:question))
      visit question_path(question)
    end

    scenario 'answers with valid fields' do
      fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
      within("form") do
        click_on 'Отправить ваш ответ'
      end

      expect(page).to have_content 'Ответ успешно создан.'
    end

    scenario "can't answer with invalid fields" do
      fill_in 'answer_body', with: ''
      within("form") do
        click_on 'Отправить ваш ответ'
      end

      expect(page).to have_content 'Текст недостаточной длины'
    end
  end

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