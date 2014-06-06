require_relative '../acceptance_helper'

feature 'User votes for answer',
%{
  In order to show my attitude
  As a user
  I want to vote for a answer
  } do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given!(:answer)  { create(:answer, question: question) }

  context 'when logged in' do
    background { sign_in_with(user.email, user.password) }

    context 'with AJAX' do
      background { visit question_path(question) }

      scenario "votes up", js: true do
        within("#answer-#{answer.id}") do
          click_on 'Голосовать за'
        end

        within("#answer-#{answer.id}") do
          expect(page).to have_css '.vote-sum', text: '1'
          expect(page).to have_content 'Вы проголосовали за'
        end
      end

      scenario "votes down", js: true do
        within("#answer-#{answer.id}") do
          click_on 'Голосовать против'
        end

        within("#answer-#{answer.id}") do
          expect(page).to have_css '.vote-sum', text: '-1'
          expect(page).to have_content 'Вы проголосовали против'
        end
      end
    end

    context 'without AJAX' do
      background { visit question_path(question) }

      scenario "votes up" do
        within("#answer-#{answer.id}") do
          click_on 'Голосовать за'
        end

        within("#answer-#{answer.id}") do
          expect(page).to have_css '.vote-sum', text: '1'
          expect(page).to have_content 'Вы проголосовали за'
        end
      end

      scenario "votes down" do
        within("#answer-#{answer.id}") do
          click_on 'Голосовать против'
        end

        within("#answer-#{answer.id}") do
          expect(page).to have_css '.vote-sum', text: '-1'
          expect(page).to have_content 'Вы проголосовали против'
        end
      end
    end
  end
end