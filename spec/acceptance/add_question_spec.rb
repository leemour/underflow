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

    scenario 'create with valid fields' do
      fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
      fill_in 'question_body',
        with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
      within("form") do
        click_on 'Задать вопрос'
      end

      expect(page).to have_content 'Вопрос успешно создан.'
      expect(page).to have_content 'Тестовый заголовок вопроса'
    end

    scenario "can't create with invalid fields" do
      fill_in 'Заголовок', with: 'Коротко'
      fill_in 'question_body',
        with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
      within("form") do
        click_on 'Задать вопрос'
      end

      expect(page).to have_content 'Заголовок недостаточной длины'
      expect(page).to_not have_content 'Коротко'
    end
  end

  context 'when not logged in' do
    scenario "can't create question" do
      visit questions_path
      click_on 'Задать вопрос'

      fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
      fill_in 'question_body',
        with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
      within("form") do
        click_on 'Задать вопрос'
      end

      expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
      expect(page).to_not have_content 'Тестовый заголовок вопроса'
    end
  end
end