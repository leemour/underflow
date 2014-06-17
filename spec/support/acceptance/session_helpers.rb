module Acceptance
  module SessionHelpers
    def sign_up_with(name, email, password)
      visit new_user_registration_path
      within '#registration-form' do
        fill_in 'Имя',    with: name
        fill_in 'E-mail', with: email
        fill_in 'Пароль', with: password
        fill_in 'Подтверждение пароля', with: password
        click_on 'Зарегистрироваться'
      end
    end

    def sign_in_with(email, password)
      visit new_user_session_path
      within '#login-form' do
        fill_in 'Логин', with: email
        fill_in 'Пароль', with: password
        click_on 'Войти'
      end
    end

    def sign_in_with_account(provider)
      visit new_user_session_path
      within '#login-form' do
        click_on "Войти через #{provider.capitalize}"
      end
    end
  end
end