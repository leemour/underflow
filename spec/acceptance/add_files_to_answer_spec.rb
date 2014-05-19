require_relative '../acceptance_helper'

feature 'Add files to answer',
%q{
  In order to illustrate my answer
  As answer author
  I want to attach files to answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  background do
    sign_in_with(user.email, user.password)
    visit question_path(question)
  end

  scenario "when creating Answer" do
    within("#answer-#{answer.id}") do
      fill_in 'answer_body', with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос.'
      attach_file 'Файл', File.join(Rails.root, "spec", "spec_helper.rb")
      click_on 'Отправить ваш ответ'
    end

    expect(page).to have_link 'spec_helper.rb'
  end


  context "when editing Answer" do
    scenario "with AJAX", js: true do
      within("#answer-#{answer.id}") do
        click_on 'Редактировать'
        attach_file 'Файл', File.join(Rails.root, "spec", "spec_helper.rb")
        click_on 'Отправить ваш ответ'
      end

      within("#answer-#{answer.id}") do
        expect(page).to have_link 'spec_helper.rb',
          href: "/uploads/attachment/test/answer-#{answer.id}/spec_helper.rb"
      end
    end

    scenario "without AJAX" do
      within("#answer-#{answer.id}") do
        click_on 'Редактировать'
        attach_file 'Файл', File.join(Rails.root, "spec", "spec_helper.rb")
        click_on 'Отправить ваш ответ'
      end

      within("#answer-#{answer.id}") do
        expect(page).to have_link 'spec_helper.rb',
          href: "/uploads/attachment/test/answer-#{answer.id}/spec_helper.rb"
      end
    end
  end
end