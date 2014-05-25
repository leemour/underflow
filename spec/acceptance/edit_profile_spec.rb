require_relative '../acceptance_helper'

feature 'User edits his profile',
%{
  In order to show my photo to other users
  As a user
  I want to add avatar to my profile
  } do

  given(:user) { create(:user) }

  context 'when logged in' do
    background do
      sign_in_with(user.email, user.password)
      visit user_path(user)
    end

    context 'with valid attributes' do
      scenario 'change real name' do
        click_on 'Редактировать'

        fill_in "Полное имя", with: 'Арнольд Шварцнеггер'
        click_on 'Сохранить'

        expect(page).to have_content 'Профиль успешно обновлен'
        expect(page).to have_content 'Арнольд Шварцнеггер'
      end
    end

    context 'with invalid attributes' do
      scenario "doesn't change real name" do
        click_on 'Редактировать'

        fill_in "Полное имя", with: '&&&'
        click_on 'Сохранить'

        expect(page).to have_content 'Полное имя имеет неверное значение'
      end
    end
  end

  context 'when not logged in' do
    scenario "can't see edit link" do
      visit user_path(user)
      expect(page).to_not have_link 'Редактировать'
    end
  end
end
