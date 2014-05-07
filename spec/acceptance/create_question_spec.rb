require 'spec_helper'

feature 'User creates question',
%{
  In order to receive answers
  As a user
  I want to ask questions
  } do

  scenario 'with valid fields' do
    create(:user, email: '123@mail.ru', password: '12345678')
    sign_in_with('123@mail.ru', '12345678')

    visit questions_path
    click_on 'Задать вопрос'

    fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
    fill_in 'new-question-body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
    within("form") do
      click_on 'Задать вопрос'
    end

    expect(page).to have_content 'Вопрос успешно создан.'
  end

  scenario 'with invalid fields' do
    create(:user, email: '123@mail.ru', password: '12345678')
    sign_in_with('123@mail.ru', '12345678')

    visit questions_path
    click_on 'Задать вопрос'

    fill_in 'Заголовок', with: 'Короткий'
    fill_in 'new-question-body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
    within("form") do
      click_on 'Задать вопрос'
    end

    expect(page).to have_content 'Заголовок недостаточной длины'
  end

  scenario 'when user not logged in' do
    visit questions_path
    click_on 'Задать вопрос'

    fill_in 'Заголовок', with: 'Короткий'
    fill_in 'new-question-body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
    within("form") do
      click_on 'Задать вопрос'
    end

    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end