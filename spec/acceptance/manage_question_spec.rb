require_relative '../acceptance_helper'

feature 'User manages his question',
%{
  In order to change details
  As a user
  I want to edit or delete my own question
  } do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'when not logged in' do
    background { visit question_path(question) }

    scenario "can't see edit links" do
      within("#question-#{question.id}") do
        expect(page).to_not have_link 'Редактировать'
      end
    end

    scenario "can't see delete links" do
      within("#question-#{question.id}") do
        expect(page).to_not have_link 'Удалить'
      end
    end
  end

  context "in other user's questions" do
    background do
      other_user = create(:user)
      sign_in_with(other_user.email, other_user.password)
      visit question_path(question)
    end

    scenario "can't see edit links" do
      within("#question-#{question.id}") do
        expect(page).to_not have_link 'Редактировать'
      end
    end

    scenario "can't see delete links" do
      within("#question-#{question.id}") do
        expect(page).to_not have_link 'Удалить'
      end
    end
  end

  context "in user's own questions" do
    background do
      sign_in_with(user.email, user.password)
      visit question_path(question)
    end

    context 'with AJAX' do
      feature 'edits question' do
        scenario 'with correct attributes', js: true do
          click_on 'Редактировать'
          fill_in 'question_body',
            with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
          within("#edit-question-form") do
            click_on 'Задать вопрос'
          end
          expect(page).to have_content 'Вопрос успешно обновлен.'
          expect(page).to have_content 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
        end

        scenario 'with incorrect attributes', js: true do
          click_on 'Редактировать'
          fill_in 'question_body', with: ''
          within("#edit-question-form") do
            click_on 'Задать вопрос'
          end
          expect(page).to have_content 'Текст недостаточной длины'
        end
      end
    end

    context 'without AJAX' do
      feature 'edits question' do
        scenario 'with correct attributes' do
          click_on 'Редактировать'
          within("#edit-question-form") do
            fill_in 'question_body',
              with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
            click_on 'Задать вопрос'
          end
          expect(page).to have_content 'Вопрос успешно обновлен.'
          expect(page).to have_content 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
        end

        scenario 'with incorrect attributes' do
          click_on 'Редактировать'
          within("#edit-question-form") do
            fill_in 'question_body', with: ''
            click_on 'Задать вопрос'
          end
          expect(page).to have_content 'Текст недостаточной длины'
        end
      end
    end

    feature "deletes answer" do
      scenario 'with AJAX', js: true do
        click_on 'Удалить'
        expect(page).to have_content 'Вопрос успешно удален.'
        expect(page).to_not have_content question.body
      end

      scenario 'without AJAX' do
        click_on 'Удалить'
        expect(page).to have_content 'Вопрос успешно удален.'
        expect(page).to_not have_content question.body
      end
    end
  end
end