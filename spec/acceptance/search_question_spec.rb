require_relative '../acceptance_helper'

feature 'User searches questions',
%{
  In order to find solution to my problem
  As a user
  I want to find questions with particular words
  } do

  background do
    create(:question, body: 'Невероятно сложный вопрос, который надо решить')
    create(:question, body: 'Довольно сложный вопрос, который надо решить')
    create(:question, body: 'Очень простой вопрос, который надо решить')
    ThinkingSphinx::Test.index

    visit root_path
  end

  context 'when searching for 1 word' do
    scenario 'finds questions containing it', sphinx:  true do
      within("#search") do
        fill_in "q", with: 'сложный'
        click_on 'Искать'
      end

      expect(page).to have_content 'Невероятно сложный вопрос'
      expect(page).to have_content 'Довольно сложный вопрос'
      expect(page).to_not have_content 'Очень простой вопрос'
    end
  end

  context 'when searching for multiple words' do
    scenario 'finds questions containing all of them' do
      within("#search") do
        fill_in "q", with: 'сложный довольно'
        click_on 'Искать'
      end

      expect(page).to have_content 'Довольно сложный вопрос'
      expect(page).to_not have_content 'Невероятно сложный вопрос'
      expect(page).to_not have_content 'Очень простой вопрос'
    end
  end
end