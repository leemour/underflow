require_relative '../acceptance_helper'

feature 'User manages a profile',
%{
  In order to change information about myself
  As a user
  I want to manage my profile
  } do

  given(:user) { create(:user) }
  background { create(:profile, user: user) }

  context "when other user's profile" do
    scenario "doesn't have Edit link" do
      visit user_path(user)

      expect(page).to_not have_link 'Редактировать'
    end
  end

  context 'when own profile' do
    background { sign_in_with(user.email, user.password) }

    feature 'edits profile' do
      scenario 'with correct attributes' do
        visit user_path(user)
        click_on 'Редактировать'

        fill_in 'Полное имя', with: 'Ben Johnson'
        fill_in 'О себе', with: 'Web developer'
        click_on 'Сохранить'

        expect(current_path).to eq(user_path(user))
        expect(page).to have_content 'Ben Johnson'
        expect(page).to have_content 'Web developer'
      end

      scenario 'with incorrect attributes' do
        visit user_path(user)
        click_on 'Редактировать'

        fill_in 'Полное имя', with: '&&&'
        fill_in 'О себе', with: 'Web developer'
        click_on 'Сохранить'

        expect(page).to have_content 'Полное имя имеет неверное значение'
      end
    end
  end
end