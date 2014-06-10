require_relative '../acceptance_helper'

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
      question = create(:question, user: user)
      visit question_path(question)
    end

    context 'with valid body' do
      context 'with AJAX' do
        scenario 'adds answer', js: true do
          within("#new-answer-form") do
            fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
            click_on 'Отправить ваш ответ'
          end

          expect(page).to have_content 'Ответ успешно создан.'
          expect(page).to have_content 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
        end
      end

      context 'without AJAX' do
        scenario 'adds answer' do
          within("#new-answer-form") do
            fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
            click_on 'Отправить ваш ответ'
          end

          expect(page).to have_content 'Ответ успешно создан.'
          expect(page).to have_content 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
        end
      end
    end

    context 'with invalid body' do
      context 'with AJAX' do
        scenario "doesn't add answer", js: true do
          fill_in 'answer_body', with: ''
          within("#new-answer-form") do
            click_on 'Отправить ваш ответ'
          end

          expect(page).to have_content 'Текст недостаточной длины'
        end
      end

      context 'without AJAX' do
        scenario "doesn't add answer" do
          fill_in 'answer_body', with: ''
          within("#new-answer-form") do
            click_on 'Отправить ваш ответ'
          end

          expect(page).to have_content 'Текст недостаточной длины'
        end
      end
    end
  end

  context 'when not logged in' do
    scenario "can't answer question" do
      question = create(:question)
      visit question_path(question)

      fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
      within("#new-answer-form") do
        click_on 'Отправить ваш ответ'
      end

      expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
    end
  end
end