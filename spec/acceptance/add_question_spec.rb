require_relative '../acceptance_helper'

feature 'User creates question',
%{
  In order to receive answers
  As a user
  I want to ask questions
  } do

  context 'when logged in' do
    background  do
      user = create(:user)
      sign_in_with(user.email, user.password)

      visit questions_path
      click_on 'Задать вопрос'
    end

    context 'with AJAX' do
      scenario 'create with valid fields', js: true do
        within("#new-question-form") do
          fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
          fill_in 'question_body',
            with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
          click_on 'Задать вопрос'
        end

        expect(page).to have_content 'Вопрос успешно создан.'
        expect(page).to have_content 'Тестовый заголовок вопроса'
      end

      scenario "can't create with invalid fields", js: true do
        within("#new-question-form") do
          fill_in 'Заголовок', with: 'Коротко'
          fill_in 'question_body',
            with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
          click_on 'Задать вопрос'
        end

        expect(page).to have_content 'Заголовок недостаточной длины'
        expect(page).to_not have_content 'Коротко'
      end
    end

    context 'without AJAX' do
      scenario 'create with valid fields' do
        within("#new-question-form") do
          fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
          fill_in 'question_body',
            with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
          click_on 'Задать вопрос'
        end

        expect(page).to have_content 'Вопрос успешно создан.'
        expect(page).to have_content 'Тестовый заголовок вопроса'
      end

      scenario "can't create with invalid fields" do
          within("#new-question-form") do
          fill_in 'Заголовок', with: 'Коротко'
          fill_in 'question_body',
            with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
          click_on 'Задать вопрос'
        end

        expect(page).to have_content 'Заголовок недостаточной длины'
        expect(page).to_not have_content 'Коротко'
      end
    end
  end

  context 'when not logged in' do
    scenario "can't create question" do
      visit questions_path
      click_on 'Задать вопрос'
      expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться'
    end
  end
end