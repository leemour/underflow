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
    visit new_question_path
  end

  scenario "add files" do
    fill_in 'Заголовок', with: 'Тестовый заголовок вопроса'
    fill_in 'question_body',
      with: 'Это коварный вопрос. Это коварный вопрос. Это коварный вопрос. '
    attach_file 'Файл', File.join(Rails.root, "spec", "spec_helper.rb")

    within("form") do
      click_on 'Задать вопрос'
    end

    expect(page).to have_content "spec_helper.rb"
  end

end