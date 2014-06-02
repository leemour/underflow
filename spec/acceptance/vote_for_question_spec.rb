require_relative '../acceptance_helper'

feature 'User votes for question',
%{
  In order to show my attitude
  As a user
  I want to vote for a question
  } do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'when logged in' do
    background { sign_in_with(user.email, user.password) }

    context 'with AJAX' do
      background { visit question_path(question) }

      scenario "votes up", js: true do
        click_on 'Голосовать за'

        expect(page).to have_css '.vote-sum', text: '1'
        within("#question-#{question.id}") do
          expect(page).to have_content 'Вы проголосовали за'
        end
      end

      scenario "votes down", js: true do
        click_on 'Голосовать против'

        expect(page).to have_css '.vote-sum', text: '-1'
        within("#question-#{question.id}") do
          expect(page).to have_content 'Вы проголосовали против'
        end
      end
    end

    context 'without AJAX' do
      background { visit question_path(question) }

      scenario "votes up" do
        click_on 'Голосовать за'

        expect(page).to have_css '.vote-sum', text: '1'
        within("#question-#{question.id}") do
          expect(page).to have_content 'Вы проголосовали за'
        end
      end

      scenario "votes down" do
        click_on 'Голосовать против'

        expect(page).to have_css '.vote-sum', text: '-1'
        within("#question-#{question.id}") do
          expect(page).to have_content 'Вы проголосовали против'
        end
      end
    end
  end
end