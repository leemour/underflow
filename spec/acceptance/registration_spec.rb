require 'spec_helper'

feature 'User creates account',
%{
  In order to ask questions
  As a user
  I want to register an account
  } do

  scenario 'with valid fields' do
    sign_up_with('peter', '123@mail.ru', '12345678')

    expect(page).to have_content 'Вы успешно зарегистрировались.'
  end

  scenario 'with invalid fields' do
    sign_up_with('', '123@mail.ru', '12345678')

    expect(page).to have_content 'Имя не может быть пустым'
  end
end