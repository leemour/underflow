require_relative '../acceptance_helper'

feature 'User chooses best answer',
%{
  In order to indicate the solution to my question
  As a question creator
  I want to choose the best answer
  } do

  given(:user)     { create(:user) }
  given(:user2)    { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, user: user2) }
  given!(:answer2) { create(:answer, question: question,
    body: 'Second answer body, different from first answer body. Good one') }

  context 'when logged in' do
    background { sign_in_with(user.email, user.password) }

    context 'with AJAX' do
      background { visit question_path(question) }

      scenario "accepts the answer", js: true do
        within("#answer-#{answer2.id}") do
          click_on 'Выбрать лучший ответ'
        end

        within("#answer-#{answer2.id}") do
          expect(page).to have_content 'Лучший ответ'
        end
        within("#answer-#{answer1.id}") do
          expect(page).to_not have_content 'Лучший ответ'
        end
        expect(answer2.body).to appear_before(answer1.body)
      end
    end

    context 'without AJAX' do
      background do
        visit question_path(question)
        within("#answer-#{answer2.id}") do
          click_on 'Выбрать лучший ответ'
        end
      end

      scenario "marks accepted answer" do
        within("#answer-#{answer2.id}") do
          expect(page).to have_content 'Лучший ответ'
        end
        within("#answer-#{answer1.id}") do
          expect(page).to_not have_content 'Лучший ответ'
        end
      end

      scenario "makes accepted answer first answer" do
        expect(answer2.body).to appear_before(answer1.body)
      end
    end

    context 'when Question has Bounty' do
      background do
        create(:bounty, question: question)
        visit question_path(question)
      end

      context 'with AJAX' do
        scenario "awards bounty to user", js: true do
          within("#answer-#{answer1.id}") do
            click_on 'Выбрать лучший ответ'
          end

          expect(page).to have_content "Пользователь #{user2.name} получил награду"
        end
      end

      context 'without AJAX' do
        scenario "awards bounty to user" do
          within("#answer-#{answer1.id}") do
            click_on 'Выбрать лучший ответ'
          end

          expect(page).to have_content "Пользователь #{user2.name} получил награду"
        end
      end
    end
  end

  context "when not my question in" do
    background do
      other_user = create(:user)
      sign_in_with(other_user.email, other_user.password)
      visit question_path(question)
    end

    scenario "can't see best answer button" do
      expect(page).to_not have_link 'Выбрать лучший ответ'
    end
  end

  context 'when not logged in' do
    background { visit question_path(question) }

    scenario "can't see best answer button" do
      expect(page).to_not have_link 'Выбрать лучший ответ'
    end
  end
end