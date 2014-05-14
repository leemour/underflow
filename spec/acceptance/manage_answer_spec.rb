require_relative '../acceptance_helper'

feature 'User manages an answer',
%{
  In order to add or remove details
  As a user
  I want to manage answer
  } do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer)   { create(:answer, question: question, user: user) }


  context 'when not logged in' do
    background { visit question_path(question) }

    scenario "can't see edit links" do
      within("#answer-#{answer.id}") do
        expect(page).to_not have_link 'Редактировать'
      end
    end

    scenario "can't see delete links" do
      within("#answer-#{answer.id}") do
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
      within("#answer-#{answer.id}") do
        expect(page).to_not have_link 'Редактировать'
      end
    end

    scenario "can't see delete links" do
      within("#answer-#{answer.id}") do
        expect(page).to_not have_link 'Удалить'
      end
    end
  end

  context "in user's own questions" do
    background do
      sign_in_with(user.email, user.password)
      visit question_path(question)
    end

    feature 'edits answer' do
      background do
        within("#answer-#{answer.id}") do
          click_on 'Редактировать'
        end
      end

      context 'with AJAX' do
        scenario 'with correct text', js: true do
          within("#answer-#{answer.id}") do
            fill_in "answer-body-#{answer.id}",
              with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
            click_on 'Отправить ваш ответ'
          end

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'Ответ успешно обновлен.'
          expect(page).to have_content 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
        end

        scenario 'with incorrect text', js: true do
          within("#answer-#{answer.id}") do
            fill_in "answer-body-#{answer.id}", with: ''
            click_on 'Отправить ваш ответ'
          end

          expect(page).to have_content 'Текст недостаточной длины'
        end
      end

      context 'without AJAX' do
        scenario 'with correct text' do
          fill_in "answer_body",
            with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
          click_on 'Отправить ваш ответ'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'Ответ успешно обновлен.'
          expect(page).to have_content 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
        end

        scenario 'with incorrect text' do
          fill_in "answer_body", with: ''
          click_on 'Отправить ваш ответ'

          expect(page).to have_content 'Текст недостаточной длины'
        end
      end
    end

    feature "deletes answer" do
      scenario 'with AJAX', js: true do
        within("#answer-#{answer.id}") do
          click_on 'Удалить'
        end

        expect(page).to have_content 'Ответ успешно удален.'
        expect(page).to_not have_content answer.body
      end

      scenario 'without AJAX' do
        within("#answer-#{answer.id}") do
          click_on 'Удалить'
        end

        expect(page).to have_content 'Ответ успешно удален.'
        expect(page).to_not have_content answer.body
      end
    end
  end
end