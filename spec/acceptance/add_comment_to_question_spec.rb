require_relative '../acceptance_helper'

feature 'User adds a comment to question',
%{
  In order to annotate question
  As a user
  I want to add comment to question
  } do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'when logged in' do
    background do
      sign_in_with(user.email, user.password)
      visit question_path(question)
    end

    context 'with valid body' do
      # scenario 'with AJAX', js: true do
      #   within("#answer-form") do
      #     fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
      #     click_on 'Отправить ваш ответ'
      #   end

      #   expect(page).to have_content 'Ответ успешно создан.'
      #   expect(page).to have_content 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
      # end

      scenario 'without AJAX' do
        within("#question-#{question.id}") do
          click_on 'Комментировать'
        end

        fill_in "comment_body", with: 'Хороший комментарий'
        click_on 'Комментировать'

        expect(page).to have_content 'Комментарий успешно создан.'
        expect(page).to have_content 'Хороший комментарий'
      end
    end

    context 'with invalid body' do
    #   context 'with AJAX' do
    #     scenario "doesn't add answer", js: true do
    #       fill_in 'answer_body', with: ''
    #       within("#answer-form") do
    #         click_on 'Отправить ваш ответ'
    #       end

    #       expect(page).to have_content 'Текст недостаточной длины'
    #     end
    #   end

      context 'without AJAX' do
        scenario "doesn't add answer" do
          within("#question-#{question.id}") do
            click_on 'Комментировать'
          end

          fill_in "comment_body", with: ''
          click_on 'Комментировать'

          expect(page).to have_content 'Текст недостаточной длины'
        end
      end
    end
  end

  context 'when not logged in' do
    background { visit question_path(question) }

    scenario "can't comment question" do
      expect(page).to_not have_content 'Комментировать'
    end
  end
end