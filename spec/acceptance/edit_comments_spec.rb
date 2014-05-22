require_relative '../acceptance_helper'

feature 'User edits a comment',
%{
  In order to change information
  As a user
  I want to edit question or answer comment
  } do

  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer)  { create(:answer, question: question, user: user) }

  context 'when not logged in' do
    scenario "no question comment edit link" do
      comment = create(:question_comment, commentable: question, user: user)
      visit question_path(question)

      within("#comment-#{comment.id}") do
        expect(page).to_not have_link 'Редактировать'
      end
    end

    scenario "no answer comment edit link" do
      comment = create(:answer_comment, commentable: answer, user: user)
      visit question_path(question)

      within("#comment-#{comment.id}") do
        expect(page).to_not have_link 'Редактировать'
      end
    end
  end

  context "when other user's comment" do
    background { sign_in_with(user.email, user.password) }

    scenario "no question comment edit link" do
      comment = create(:question_comment, commentable: question)
      visit question_path(question)

      within("#comment-#{comment.id}") do
        expect(page).to_not have_link 'Редактировать'
      end
    end

    scenario "no answer comment edit link" do
      comment = create(:answer_comment, commentable: answer)
      visit question_path(question)

      within("#comment-#{comment.id}") do
        expect(page).to_not have_link 'Редактировать'
      end
    end
  end

  context 'when own comment' do
    background { sign_in_with(user.email, user.password) }

    feature "edits question comment" do
      given!(:comment) do
        create(:question_comment, commentable: question, user: user)
      end

      before { visit question_path(question) }

      scenario 'with AJAX', js: true do
        within("#comment-#{comment.id}") do
          click_on 'Редактировать'
          fill_in "comment-body-#{comment.id}", with: 'Обновленный комментарий'
          click_on 'Добавить комментарий'
        end

        expect(page).to have_content 'Комментарий успешно обновлен.'
        within("#comment-#{comment.id}") do
          expect(page).to have_content 'Обновленный комментарий'
        end
      end

      scenario 'without AJAX' do
        within("#comment-#{comment.id}") do
          click_on 'Редактировать'
        end

        fill_in "comment-body-#{comment.id}", with: 'Обновленный комментарий'
        click_on 'Добавить комментарий'

        expect(page).to have_content 'Комментарий успешно обновлен.'
        within("#comment-#{comment.id}") do
          expect(page).to have_content 'Обновленный комментарий'
        end
      end
    end

    feature "edits answer comment" do
      given!(:comment) do
        create(:answer_comment, commentable: answer, user: user)
      end
      before { visit question_path(question) }

      scenario 'with AJAX', js: true do
        within("#comment-#{comment.id}") do
          click_on 'Редактировать'
          fill_in "comment-body-#{comment.id}", with: 'Обновленный комментарий'
          click_on 'Добавить комментарий'
        end

        expect(page).to have_content 'Комментарий успешно обновлен.'
        within("#comment-#{comment.id}") do
          expect(page).to have_content 'Обновленный комментарий'
        end
      end

      scenario 'without AJAX' do
        within("#comment-#{comment.id}") do
          click_on 'Редактировать'
        end

        fill_in "comment-body-#{comment.id}", with: 'Обновленный комментарий'
        click_on 'Добавить комментарий'

        expect(page).to have_content 'Комментарий успешно обновлен.'
        within("#comment-#{comment.id}") do
          expect(page).to have_content 'Обновленный комментарий'
        end
      end
    end
  end
end