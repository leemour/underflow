require_relative '../acceptance_helper'

feature 'User adds question to favourites',
%{
  In order to save question for later
  As a user
  I want to add it to favourites
  } do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  context 'when logged in' do
    background { sign_in_with(user.email, user.password) }

    context 'with AJAX' do
      background { visit question_path(question) }

      it 'displays Question as favourite', js: true do
        click_on 'Добавить в избранное'

        expect(page).to have_content 'Добавлен в избранное'
      end

      it 'Adds question to User favourites', js: true do
        click_on 'Добавить в избранное'

        expect(page).to have_content 'Добавлен в избранное'

        visit user_favorited_questions_path(user)
        expect(page).to have_content question.title
      end
    end

    context 'without AJAX' do
      background { visit question_path(question) }

      it 'displays Question as favourite' do
        click_on 'Добавить в избранное'

        expect(page).to have_content 'Добавлен в избранное'
      end

      it 'Adds question to User favourites' do
        click_on 'Добавить в избранное'

        visit user_favorited_questions_path(user)

        expect(page).to have_content question.title
      end
    end
  end

  context 'when not logged in' do
    scenario "can't answer question" do
      visit question_path(question)
      click_on 'Добавить в избранное'

      expect(page).to have_text 'Вам необходимо войти в систему или зарегистрироваться'
      expect(page).to_not have_text 'Добавить в избранное'
    end
  end
end