require_relative '../acceptance_helper'

feature 'User adds an tag',
%{
  In order to link question to fields of knowledge
  As a user
  I want to tag the question
  } do


  given(:user) { create(:user) }

  background do
    sign_in_with(user.email, user.password)
  end

  context "when creating Question" do
    scenario "add new tag", js: true do
      visit new_question_path

      fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
      fill_in 'question_body',
        with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
      fill_in 'tag-suggest-input', with: 'ruby-on-rails,'
      within("form") do
        click_on 'Задать вопрос'
      end

      expect(page).to have_link 'ruby-on-rails'
    end

    scenario "add existing tag", js: true do
      create(:tag, name: 'ruby-on-rails')
      visit new_question_path

      fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
      fill_in 'question_body',
        with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
      fill_in 'tag-suggest-input', with: 'ruby-on-rails,'
      within("form") do
        click_on 'Задать вопрос'
      end

      expect(page).to have_link 'ruby-on-rails'
    end

    scenario "don't link unrelated tag", js: true do
      create(:tag, name: 'ruby-on-rails')
      visit new_question_path

      fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
      fill_in 'question_body',
        with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
      fill_in 'tag-suggest-input', with: 'django,'
      within("form") do
        click_on 'Задать вопрос'
      end

      expect(page).to_not have_link 'ruby-on-rails'
      expect(page).to have_link 'django'
    end
  end

  context "when editing Question" do
    given(:question) { create(:question, user: user) }

    scenario "add new tag", js: true do
      visit question_path(question)

      within("#question-#{question.id}") do
        click_on 'Редактировать'
      end

      fill_in 'tag-suggest-input', with: 'ruby-on-rails,'
      within("form.edit_question") do
        click_on 'Задать вопрос'
      end

      expect(page).to have_link 'ruby-on-rails'
    end

    scenario "remove associated tag", js: true do
      create(:tag, name: 'ruby-on-rails', questions: [question])
      visit question_path(question)

      within("#question-#{question.id}") do
        click_on 'Редактировать'
      end

      fill_in 'tag-suggest-input', with: 'django,'
      within("form.edit_question") do
        click_on 'Задать вопрос'
      end

      expect(page).to_not have_link 'ruby-on-rails'
      expect(page).to have_link 'django'
    end
  end
end