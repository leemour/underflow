require_relative '../acceptance_helper'

feature 'User logs in',
%{
  In order to ask questions
  As a user
  I want to log in
  } do

  given(:user) { create(:user) }

  scenario 'when user exists' do
    sign_in_with(user.email, user.password)
    expect(page).to have_content 'Вход в систему выполнен.'
  end

  scenario "when user doesn't exist" do
    sign_in_with('123@mail.ru', '12345678')
    expect(page).to have_content 'Неверный email или пароль.'
  end

  scenario "when incorrect password" do
    sign_in_with(user.email, '0')
    expect(page).to have_content 'Неверный email или пароль.'
  end
end