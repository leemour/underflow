require 'spec_helper'

feature 'User logs in',
%{
  In order to ask questions
  As a user
  I want to log in
  } do

  scenario 'when user exists' do
    create(:user, email: '123@mail.ru', password: '12345678')
    sign_in_with('123@mail.ru', '12345678')

    expect(page).to have_content 'Вход в систему выполнен.'
  end

  scenario "when user doesn't exist" do
    sign_in_with('123@mail.ru', '12345678')

    expect(page).to have_content 'Неверный email или пароль.'
  end

  scenario "when incorrect password" do
    create(:user, email: '123@mail.ru', password: '12345678')
    sign_in_with('123@mail.ru', '0')

    expect(page).to have_content 'Неверный email или пароль.'
  end
end