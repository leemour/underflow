require_relative '../acceptance_helper'

feature 'User logs in',
%{
  In order to ask questions
  As a user
  I want to log in
  } do

  context "with email & password" do
    given(:user) { create(:user) }

    scenario 'when user exists' do
      sign_in_with(user.email, user.password)
      expect(page).to have_content 'Вход в систему выполнен.'
      expect(page).to have_content 'Выйти'
    end

    scenario "when user doesn't exist" do
      sign_in_with('123@mail.ru', '12345678')
      expect(page).to have_content 'Неверный логин/email или пароль.'
    end

    scenario "when incorrect password" do
      sign_in_with(user.email, '0')
      expect(page).to have_content 'Неверный логин/email или пароль.'
    end
  end

  context "with Facebook" do
    before do
      OmniAuth.config.add_mock :facebook, provider: :facebook,
        uid: "1234", info: {email: "ghost@nobody.com", nickname: 'name'}
    end

    scenario 'when user already registered with email' do
      create(:user, email: "ghost@nobody.com")

      sign_in_with_account(:facebook)
      expect(page).to have_content 'Вход в систему выполнен'
      expect(page).to have_content 'Выйти'
    end

    scenario 'when new user' do
      sign_in_with_account(:facebook)
      expect(page).to have_content 'Вы должны подтвердить Вашу учётную запись'

      expect(last_email.to).to include('ghost@nobody.com')

      visit "/users/confirmation?#{confirmation_token(last_email)}"
      expect(page).to have_content 'Ваша учётная запись подтверждена'

      sign_in_with_account(:facebook)
      expect(page).to have_content ' Вход в систему выполнен с учётной записью из Facebook'
      expect(page).to have_content 'Выйти'
    end

    context "with invalid credentials" do
      before { OmniAuth.config.mock_auth[:facebook] = :invalid_credentials }

      scenario 'when new user' do
        sign_in_with_account(:facebook)
        expect(page).to have_content 'Вы не можете войти в систему с учётной записью из Facebook'
      end
    end
  end

  context "with Twitter" do
    before do
      OmniAuth.config.add_mock :twitter, provider: :twitter,
        uid: "1234", info: {nickname: 'name'}
    end

    scenario 'when user already registered with email' do
      user = create(:user, email: "ghost@nobody.com")

      sign_in_with_account(:twitter)
      expect(page).to have_content 'Введите email'

      within '#enter-email' do
        fill_in 'E-mail', with: "ghost@nobody.com"
        click_on 'Зарегистрироваться'
      end
      expect(page).to have_content 'Такой E-mail уже существует'

      within '#enter-password' do
        fill_in 'Пароль', with: user.password
        click_on 'Объединить профили'
      end
      expect(page).to have_content 'Вы успешно объединили свой профиль с профилем от Twitter'
      expect(page).to have_content 'Выйти'

      click_on 'Выйти'

      sign_in_with_account(:twitter)
      expect(page).to have_content 'Вход в систему выполнен с учётной записью из Twitter'
      expect(page).to have_content 'Выйти'
    end

    scenario 'when new user' do
      sign_in_with_account(:twitter)

      within '#enter-email' do
        fill_in 'E-mail', with: "ghost@nobody.com"
        click_on 'Зарегистрироваться'
      end

      expect(page).to have_content 'Вы получите письмо с инструкциями по подтверждению'

      expect(last_email.to).to include('ghost@nobody.com')

      visit "/users/confirmation?#{confirmation_token(last_email)}"
      expect(page).to have_content 'Ваша учётная запись подтверждена'

      sign_in_with_account(:twitter)
      expect(page).to have_content 'Вход в систему выполнен с учётной записью из Twitter'
      expect(page).to have_content 'Выйти'
    end

    context "with invalid credentials" do
      before { OmniAuth.config.mock_auth[:twitter] = :invalid_credentials }

      scenario 'when new user' do
        sign_in_with_account(:twitter)
        expect(page).to have_content 'Вы не можете войти в систему с учётной записью из Twitter'
      end
    end
  end
end