require_relative '../acceptance_helper'

feature 'User views a list of users',
%{
  In order to find other users
  As a user
  I want to see a list of users
  } do

  given!(:user1) { create(:user, name: 'John') }
  given!(:user2) { create(:user, name: 'Arnold') }

  background { visit users_path }

  scenario 'ordered by name' do
    expect(user2.name).to appear_before(user1.name)
  end

  scenario 'with name as a link to user profile' do
    expect(page).to have_link 'John', href: user_path(user1)
  end
end