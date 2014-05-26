require_relative '../acceptance_helper'

feature 'User views a tag',
%{
  In order to see tag info
  As a user
  I want to see a tag page
  } do

  given(:tag) { create(:tag) }
  background { visit tag_path(tag) }

  scenario 'with name, description and excerpt' do
    expect(page).to have_css 'h1', tag.name
    expect(page).to have_content tag.excerpt
    expect(page).to have_content tag.description
  end
end