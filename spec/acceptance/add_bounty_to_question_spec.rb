require_relative '../acceptance_helper'

feature 'User adds bounty to his question',
%{
  In order to motivate users to answer my question
  As a question author
  I want to add bounty for best answer
  } do

  given(:user) { create(:user) }

  context 'when Question author' do
    before { sign_in_with(user.email, user.password) }
    given(:question) { create(:question, user: user) }

    scenario 'adds bounty with amount > 50' do
      visit question_path(question)

      save_and_open_page

      click_on 'Объявить награду'
      select '100', from: 'bounty_value'
      click_on 'Назначить награду'

      expect(page).to have_content 'Награда добавлена'
      expect(page).to have_content 'Размер награды 100 очков'
    end
  end

  context 'when not Question author' do
    before { sign_in_with(user.email, user.password) }
    given(:question) { create(:question) }

    scenario "can't see add bounty link" do
      visit question_path(question)

      expect(page).to_not have_link 'Добавить награду'
    end
  end

  context 'when not signed in' do
    scenario "can't see add bounty link" do
      visit question_path(question)

      expect(page).to_not have_link 'Добавить награду'
    end
  end
end