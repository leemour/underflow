require 'spec_helper'

feature 'User logs in',
%{
  In order to ask questions
  As a user
  I want to log in
  } do

  scenario 'when user exists' do
    create(:user, email: '123@mail.ru', password: '12345678')

    visit new_user_session_path
    fill_in 'E-mail', with: '123@mail.ru'
    fill_in 'Пароль', with: '12345678'
    within 'form' do
      click_on 'Войти'
    end

    expect(page).to have_content 'Вход в систему выполнен.'
  end

  scenario "when user doesn't exist" do
    visit new_user_session_path
    fill_in 'E-mail', with: '123@mail.ru'
    fill_in 'Пароль', with: '12345678'
    within 'form' do
      click_on 'Войти'
    end

    expect(page).to have_content 'Неверный email или пароль.'
  end

  scenario "when incorrect password" do
    create(:user, email: '123@mail.ru', password: '12345678')

    visit new_user_session_path
    fill_in 'E-mail', with: '123@mail.ru'
    fill_in 'Пароль', with: '0'
    within 'form' do
      click_on 'Войти'
    end

    expect(page).to have_content 'Неверный email или пароль.'
  end
end