require 'spec_helper'



feature 'User creates question',
%{
  In order to receive answers
  As a user
  I want to ask questions
  } do

  scenario 'with valid fields' do
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
    visit questions_path
    click_on 'Задать вопрос'

    fill_in 'Заголовок', with: 'Короткий'
    fill_in 'new-question-body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
    within("form") do
      click_on 'Задать вопрос'
    end

    # save_and_open_page
    expect(page).to have_content 'Заголовок недостаточной длины'
  end
end