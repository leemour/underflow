module Acceptance
  module SessionHelpers
    def sign_up_with(name, email, password)
      visit new_user_registration_path
      fill_in 'Имя',    with: name
      fill_in 'E-mail', with: email
      fill_in 'Пароль', with: password
      fill_in 'Подтверждение пароля', with: password
      within 'form' do
        click_on 'Зарегистрироваться'
      end
    end

    def sign_in_with(email, password)
      visit new_user_session_path
      fill_in 'E-mail', with: email
      fill_in 'Пароль', with: password
      within 'form' do
        click_on 'Войти'
      end
    end
  end
end