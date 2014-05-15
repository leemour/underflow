require_relative '../acceptance_helper'

feature 'User views a profile',
%{
  In order to get info about a user
  As a user
  I want to see user profile
  } do

  given(:user) { create(:user) }
  background { create(:profile, user: user) }

  context "when other user's profile" do
    background { visit user_path(user) }

    scenario 'has name, real_name, website, location, about' do
      expect(page).to have_content user.name
      expect(page).to have_content user.real_name
      expect(page).to have_content user.website
      expect(page).to have_content user.location
      expect(page).to have_content user.about
    end

    scenario "doesn't have private attributes" do
      expect(page).to_not have_content user.email
    end
  end

  context 'when own profile' do
    background { sign_in_with(user.email, user.password) }

    scenario "has private attributes" do
      visit user_path(user)

      expect(page).to have_content user.email
    end
  end

  context "view all" do
    given!(:questions) { create_list(:question, 5, user: user) }
    given!(:answers) { create_list(:answer, 5, user: user) }
    background { visit user_path(user) }

    scenario "user's questions" do
      click_on '5 вопросов'

      expect(page).to have_content questions[0].title
      expect(page).to have_content questions[1].title
      expect(page).to have_content questions[4].title
    end

    scenario "user's answers" do
      click_on '5 ответов'

      expect(page).to have_content answers[0].body
      expect(page).to have_content answers[1].body
      expect(page).to have_content answers[4].body
    end
  end
end