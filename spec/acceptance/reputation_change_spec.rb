require_relative '../acceptance_helper'

feature 'System changes user reputation',
%{
  In order to reward user actions
  As a system owner
  I want to increase user reputation
  } do

  context "when other user Question" do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    background { sign_in_with(user.email, user.password) }

    context 'when created first Answer' do
      scenario 'increases User reputation by 2' do
        visit user_path(user)
        expect(page).to have_selector '.user-reputation', text: '0'

        visit question_path(question)
        within("#new-answer-form") do
          fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
          click_on 'Отправить ваш ответ'
        end

        visit user_path(user)
        expect(page).to have_selector '.user-reputation', text: '2'
      end
    end

    context 'when created second Answer' do
      background { create(:answer, question: question) }

      scenario 'increases User reputation by 1' do
        visit user_path(user)
        expect(page).to have_selector '.user-reputation', text: '0'

        visit question_path(question)
        within("#new-answer-form") do
          fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
          click_on 'Отправить ваш ответ'
        end

        visit user_path(user)
        expect(page).to have_selector '.user-reputation', text: '1'
      end
    end
  end

  context "when own Question" do
    given(:user) { create(:user) }
    given(:question) { create(:question, user: user) }
    background { sign_in_with(user.email, user.password) }

    context 'when created first Answer' do
      scenario 'increases User reputation by 3' do
        visit user_path(user)
        expect(page).to have_selector '.user-reputation', text: '0'

        visit question_path(question)
        within("#new-answer-form") do
          fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
          click_on 'Отправить ваш ответ'
        end

        visit user_path(user)
        expect(page).to have_selector '.user-reputation', text: '3'
      end
    end

    context 'when created second Answer' do
      background { create(:answer, question: question) }

      scenario 'increases User reputation by 2' do
        visit user_path(user)
        expect(page).to have_selector '.user-reputation', text: '0'

        visit question_path(question)
        within("#new-answer-form") do
          fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
          click_on 'Отправить ваш ответ'
        end

        visit user_path(user)
        expect(page).to have_selector '.user-reputation', text: '2'
      end
    end
  end

  context "when voted" do
    given(:author) { create(:user) }
    given(:user) { create(:user) }
    given(:question) { create(:question, user: author) }
    background { sign_in_with(user.email, user.password) }

    context 'for Question' do
      context 'up' do
        scenario 'increases User reputation by 2' do
          visit user_path(author)
          expect(page).to have_selector '.user-reputation', text: '0'

          visit question_path(question)
           within("#question-#{question.id}") do
            click_on 'Голосовать за'
          end

          visit user_path(author)
          expect(page).to have_selector '.user-reputation', text: '2'
        end
      end

      context 'down' do
        scenario 'decreases User reputation by -2' do
          visit user_path(author)
          expect(page).to have_selector '.user-reputation', text: '0'

          visit question_path(question)
           within("#question-#{question.id}") do
            click_on 'Голосовать против'
          end

          visit user_path(author)
          expect(page).to have_selector '.user-reputation', text: '-2'
        end
      end
    end

    context 'for Answer' do
      given!(:answer) { create(:answer, question: question, user: author) }

      context 'up' do
        scenario 'increases User reputation by 1' do
          visit user_path(author)
          expect(page).to have_selector '.user-reputation', text: '3'

          visit question_path(question)
          within("#answer-#{answer.id}") do
            click_on 'Голосовать за'
          end

          visit user_path(author)
          expect(page).to have_selector '.user-reputation', text: '4'
        end
      end

      context 'down' do
        scenario 'decreases User reputation by -1' do
          visit user_path(author)
          expect(page).to have_selector '.user-reputation', text: '3'

          visit question_path(question)
          within("#answer-#{answer.id}") do
            click_on 'Голосовать против'
          end

          visit user_path(author)
          expect(page).to have_selector '.user-reputation', text: '2'
        end
      end
    end
  end
end