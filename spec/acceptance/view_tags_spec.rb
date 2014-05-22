require_relative '../acceptance_helper'

feature 'User views a tag',
%{
  In order to see tag info
  As a user
  I want to see a tag page
  } do

  context 'view list of tags' do
    given!(:tag1) { create(:tag, name: 'bbbbbbbb') }
    given!(:tag2) { create(:tag, name: 'cccccccc') }
    given!(:tag3) { create(:tag, name: 'aaaaaaaa') }

    scenario "all tags ordered by name" do
      visit tags_path

      expect(tag3.name).to appear_before(tag1.name)
      expect(tag1.name).to appear_before(tag2.name)
    end
  end


  context 'view single tag' do
    given(:tag) { create(:tag) }

    scenario 'with name, description and excerpt' do
      visit tag_path(tag)

      expect(page).to have_css 'h1', tag.name
      expect(page).to have_content tag.excerpt
      expect(page).to have_content tag.description
    end
  end
end