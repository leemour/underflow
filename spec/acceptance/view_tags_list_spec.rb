require_relative '../acceptance_helper'

feature 'User views a list of tags',
%{
  In order to find navigate questions by tag
  As a user
  I want to see a list of tags
  } do

  given!(:tag1) { create(:tag, name: 'c++') }
  given!(:tag2) { create(:tag, name: 'ruby') }
  given!(:tag3) { create(:tag, name: 'assembler') }

  background { visit tags_path }

  scenario "ordered by name" do
    expect(tag3.name).to appear_before(tag1.name)
    expect(tag1.name).to appear_before(tag2.name)
  end

  scenario 'with name as a link to tag' do
    expect(page).to have_link 'ruby', href: tag_path(tag2)
  end
end