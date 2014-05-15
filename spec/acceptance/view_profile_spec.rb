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
    scenario 'has name, real_name, website, location, about' do
      visit user_path(user)

      expect(page).to have_content user.name
      expect(page).to have_content user.real_name
      expect(page).to have_content user.website
      expect(page).to have_content user.location
      expect(page).to have_content user.about
    end

    scenario "doesn't have private attributes" do
      visit user_path(user)

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
end