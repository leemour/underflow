require_relative '../acceptance_helper'

feature 'User adds a comment to answer',
%{
  In order to annotate answer
  As a user
  I want to add comment to answer
  } do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  given!(:answer)  { create(:answer, question: question) }

  context 'when logged in' do
    background do
      sign_in_with(user.email, user.password)
      visit question_path(question)
    end

    context 'with valid body' do
      scenario 'with AJAX', js: true do
        within("#answer-#{answer.id}") do
          click_on 'Комментировать'
          fill_in "comment_body", with: 'Хороший комментарий'
          click_on 'Добавить комментарий'
        end


        expect(page).to have_content 'Комментарий успешно создан.'
        within("#answer-#{answer.id}") do
          expect(page).to have_content 'Хороший комментарий'
        end
      end

      scenario 'without AJAX' do
        within("#answer-#{answer.id}") do
          click_on 'Комментировать'
        end

        fill_in "comment_body", with: 'Хороший комментарий'
        click_on 'Добавить комментарий'

        expect(page).to have_content 'Комментарий успешно создан.'
        expect(page).to have_content 'Хороший комментарий'
      end
    end

    context 'with invalid body' do
      context 'with AJAX' do
        scenario "doesn't add answer", js: true do
          within("#answer-#{answer.id}") do
            click_on 'Комментировать'
            fill_in "comment_body", with: ''
            click_on 'Добавить комментарий'
          end

          within("#answer-#{answer.id}") do
            expect(page).to have_content 'Текст недостаточной длины'
          end
        end
      end

      context 'without AJAX' do
        scenario "doesn't add answer" do
          within("#answer-#{answer.id}") do
            click_on 'Комментировать'
          end

          fill_in "comment_body", with: ''
          click_on 'Добавить комментарий'

          expect(page).to have_content 'Текст недостаточной длины'
        end
      end
    end
  end

  context 'when not logged in' do
    background { visit question_path(question) }

    scenario "can't comment answer" do
      within("#answer-#{answer.id}") do
        expect(page).to_not have_content 'Комментировать'
      end
    end
  end
end