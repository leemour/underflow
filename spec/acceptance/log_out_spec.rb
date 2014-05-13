require_relative '../acceptance_helper'

feature 'User logs out',
%{
  In order to change account
  As a user
  I want to log out of existing account
  } do

  scenario 'when already logged in' do
    user = create(:user)
    sign_in_with(user.email, user.password)

    visit '/'
    click_link 'Выйти'

    expect(page).not_to have_link 'Выйти'
    expect(page).to have_link 'Войти'
    expect(page).to have_link 'Регистрация'
  end

  scenario 'when not logged in in' do
    visit '/'

    expect(page).not_to have_link 'Выйти'
  end
end
