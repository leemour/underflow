require_relative '../acceptance_helper'

feature 'User deletes a comment',
%{
  In order to remove unneccessary information
  As a user
  I want to delete question or answer comment
  } do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  context 'when not logged in' do
    scenario "no question comment delete link" do
      comment = create(:question_comment, commentable: question, user: user)
      visit question_path(question)

      within("#comment-#{comment.id}") do
        expect(page).to_not have_link 'Удалить'
      end
    end

    scenario "no answer comment delete link" do
      comment = create(:answer_comment, commentable: answer, user: user)
      visit question_path(question)

      within("#comment-#{comment.id}") do
        expect(page).to_not have_link 'Удалить'
      end
    end
  end

  context "when other user's comment" do
    background { sign_in_with(user.email, user.password) }

    scenario "no question comment delete link" do
      comment = create(:question_comment, commentable: question)
      visit question_path(question)

      within("#comment-#{comment.id}") do
        expect(page).to_not have_link 'Удалить'
      end
    end

    scenario "no answer comment delete link" do
      comment = create(:answer_comment, commentable: answer)
      visit question_path(question)

      within("#comment-#{comment.id}") do
        expect(page).to_not have_link 'Удалить'
      end
    end
  end

  context 'when own comment' do
    background { sign_in_with(user.email, user.password) }

    feature "deletes question comment" do
      given!(:comment) do
        create(:question_comment, commentable: question, user: user)
      end
      before { visit question_path(question) }

      scenario 'with AJAX', js: true do
        within("#comment-#{comment.id}") do
          click_on 'Удалить'
        end

        expect(page).to have_content 'Комментарий успешно удален.'
        expect(page).to_not have_content comment.body
      end

      scenario 'without AJAX' do
        within("#comment-#{comment.id}") do
          click_on 'Удалить'
        end

        expect(page).to have_content 'Комментарий успешно удален.'
        expect(page).to_not have_content comment.body
      end
    end

    feature "deletes answer comment" do
      given!(:comment) do
        create(:answer_comment, commentable: answer, user: user)
      end
      before { visit question_path(question) }

      scenario 'with AJAX', js: true do
        within("#comment-#{comment.id}") do
          click_on 'Удалить'
        end

        expect(page).to have_content 'Комментарий успешно удален.'
        expect(page).to_not have_content comment.body
      end

      scenario 'without AJAX' do
        within("#comment-#{comment.id}") do
          click_on 'Удалить'
        end

        expect(page).to have_content 'Комментарий успешно удален.'
        expect(page).to_not have_content comment.body
      end
    end
  end
end