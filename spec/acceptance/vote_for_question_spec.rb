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

    context 'without AJAX' do
      background { visit question_path(question) }

      scenario "votes up" do
        click_on 'Голосовать за'

        within("#question-#{question.id}") do
          expect(page).to have_content 'Вы проголосовали за'
        end
      end

      scenario "votes down" do
        click_on 'Голосовать против'

        within("#question-#{question.id}") do
          expect(page).to have_content 'Вы проголосовали против'
        end
      end
    end
  end

end