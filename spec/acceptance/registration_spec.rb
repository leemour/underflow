require_relative '../acceptance_helper'

feature 'User creates account',
%{
  In order to ask questions
  As a user
  I want to register an account
  } do

  context 'with valid fields' do
    scenario 'logs in with confirmation' do
      sign_up_with('peter', '123@mail.ru', '12345678')
      expect(page).to have_content 'В течение нескольких минут Вы получите письмо с инструкциями'

      expect(last_email.to).to include('123@mail.ru')

      visit "/users/confirmation?#{confirmation_token(last_email)}"
      expect(page).to have_content 'Ваша учётная запись подтверждена'

      sign_in_with('peter', '12345678')
      expect(page).to have_content 'Вход в систему выполнен.'
      expect(page).to have_content 'Выйти'
    end

    scenario "doesn't log in without confirmation" do
      sign_up_with('peter', '123@mail.ru', '12345678')
      expect(page).to have_content 'В течение нескольких минут Вы получите письмо с инструкциями'
      expect(last_email.to).to include('123@mail.ru')

      sign_in_with('peter', '12345678')
      expect(page).to have_content 'Вы должны подтвердить Вашу учётную запись'
    end
  end

  context 'with invalid fields' do
    scenario "show error" do
      sign_up_with('', '123@mail.ru', '12345678')
      expect(page).to have_content 'Имя не может быть пустым'
    end
  end
end