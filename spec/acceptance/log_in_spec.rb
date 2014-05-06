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
    fill_in 'Email',  with: '123@mail.ru'
    fill_in 'Password', with: '12345678'
    click_on 'Sign in'

    expect(page).to have_content 'You successfully signed in.'
  end
end