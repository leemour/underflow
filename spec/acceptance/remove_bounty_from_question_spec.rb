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

    context "with AJAX" do
      scenario 'removes Bounty from Question', js: true do
        visit question_path(question)

        expect(page).to have_content 'назначена награда в +100 очков'

        click_on 'Отменить награду'

        expect(page).to have_content 'Награда успешно удалена'
        expect(page).to_not have_content 'назначена награда в +100 очков'
      end
    end

    context "with AJAX" do
      scenario 'removes Bounty from Question' do
        visit question_path(question)

        expect(page).to have_content 'назначена награда в +100 очков'

        click_on 'Отменить награду'

        expect(page).to have_content 'Награда успешно удалена'
        expect(page).to_not have_content 'назначена награда в +100 очков'
      end
    end
  end

  context 'when not Question author' do
    before { sign_in_with(user.email, user.password) }
    given(:question) { create(:question) }
    given!(:bounty)  { create(:bounty, question: question) }

    scenario "can't see remove Bounty link" do
      visit question_path(question)

      expect(page).to_not have_link 'Отменить награду'
    end
  end

  context 'when not signed in' do
    given(:question) { create(:question) }
    given!(:bounty)  { create(:bounty, question: question) }

    scenario "can't see remove Bounty link" do
      visit question_path(question)

      expect(page).to_not have_link 'Отменить награду'
    end
  end
end