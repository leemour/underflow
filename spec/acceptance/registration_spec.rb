require 'spec_helper'

feature 'User creates account',
%{
  In order to ask questions
  As a user
  I want to register an account
  } do

  scenario 'with valid fields' do
    visit new_user_registration_path
    fill_in 'Имя',    with: 'peter'
    fill_in 'E-mail', with: '123@mail.ru'
    fill_in 'Пароль', with: '12345678'
    fill_in 'Подтверждение пароля', with: '12345678'
    within 'form' do
      click_on 'Зарегистрироваться'
    end

    expect(page).to have_content 'Вы успешно зарегистрировались.'
  end

  scenario 'with invalid fields' do
    visit new_user_registration_path
    fill_in 'E-mail', with: '123@mail.ru'
    fill_in 'Пароль', with: '12345678'
    fill_in 'Подтверждение пароля', with: '12345678'
    within 'form' do
      click_on 'Зарегистрироваться'
    end

    expect(page).to have_content 'Имя не может быть пустым'
  end
end