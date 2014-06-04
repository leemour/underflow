require_relative '../acceptance_helper'

feature 'User removes bounty from his question',
%{
  In order to save my reputation
  As a question author
  I want to remove bounty from my question
  } do

  given(:user) { create(:user) }

  context 'when Question author' do
    before { sign_in_with(user.email, user.password) }
    given(:question) { create(:question, user: user) }
    given!(:bounty)  { create(:bounty, question: question, value: 100) }

    scenario 'adds bounty with amount > 50' do
      visit question_path(question)

      expect(page).to have_content 'назначена награда в +100 очков'

      click_on 'Отменить награду'

      expect(page).to have_content 'Награда успешно удалена'
      expect(page).to_not have_content 'назначена награда в +100 очков'
    end
  end

  context 'when not Question author' do
    before { sign_in_with(user.email, user.password) }
    given(:question) { create(:question) }
    given!(:bounty)  { create(:bounty, question: question) }

    scenario "can't see remove bounty link" do
      visit question_path(question)

      expect(page).to_not have_link 'Отменить награду'
    end
  end

  context 'when not signed in' do
    given(:question) { create(:question) }
    given!(:bounty)  { create(:bounty, question: question) }

    scenario "can't see remove bounty link" do
      visit question_path(question)

      expect(page).to_not have_link 'Отменить награду'
    end
  end
end