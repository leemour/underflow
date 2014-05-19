require_relative '../acceptance_helper'

feature 'Add files to question',
%q{
  In order to illustrate my question
  As question author
  I want to attach files to question
} do

  given(:user) { create(:user) }

  background do
    sign_in_with(user.email, user.password)
  end

  scenario "when creating Question" do
    visit new_question_path

    fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
    fill_in 'question_body',
      with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
    attach_file 'Файл', File.join(Rails.root, "spec", "spec_helper.rb")

    within("form") do
      click_on 'Задать вопрос'
    end

    expect(page).to have_link 'spec_helper.rb'
  end

  context "when editing Question" do
    scenario "with AJAX", js: true do
      question = create(:question, user: user)
      visit question_path(question)

      within("#question-#{question.id}") do
        click_on 'Редактировать'
        attach_file 'Файл', File.join(Rails.root, "spec", "spec_helper.rb")
        click_on 'Задать вопрос'
      end

      within("#question-#{question.id}") do
        expect(page).to have_link 'spec_helper.rb',
          href: "/uploads/attachment/test/question-#{question.id}/spec_helper.rb"
      end
    end

    scenario "without AJAX" do
      question = create(:question, user: user)
      visit question_path(question)

      within("#question-#{question.id}") do
        click_on 'Редактировать'
        attach_file 'Файл', File.join(Rails.root, "spec", "spec_helper.rb")
        click_on 'Задать вопрос'
      end

      within("#question-#{question.id}") do
        expect(page).to have_link 'spec_helper.rb',
          href: "/uploads/attachment/test/question-#{question.id}/spec_helper.rb"
      end
    end
  end
end