require_relative '../acceptance_helper'

feature 'User views list of questions',
%{
  In order to answer questions
  As a user
  I want to see a list of questions
  } do

  let!(:question1) { create(:question, title: 'Тестовый вопрос номер 1') }
  let!(:question2) { create(:question, title: 'Тестовый вопрос номер 2') }
  let!(:question3) { create(:question, title: 'Тестовый вопрос номер 3') }

  context 'All (latest) questions' do
    scenario 'ordered by date newest first' do
      visit root_path

      expect(question2.title).to appear_before(question1.title)
      expect(question3.title).to appear_before(question2.title)
    end
  end

  context 'Unanswered questions' do
    before do
      create(:answer, question: question1)
      visit unanswered_questions_path
    end

    scenario 'ordered by date newest first' do
      visit unanswered_questions_path

      expect(question3.title).to appear_before(question2.title)
    end

    scenario "only questions with 0 answeres" do
      visit unanswered_questions_path

      expect(page).to_not have_content(question1.title)
      expect(page).to have_content(question2.title)
      expect(page).to have_content(question3.title)
    end
  end

  context 'Popular questions' do
    scenario 'ordered by views count' do
      visit question_path(question1)
      visit popular_questions_path

      expect(question1.title).to appear_before(question2.title)
    end
  end

  context 'Most voted questions' do
    before do
      user1 = create(:user)
      user2 = create(:user)
      question1.vote_up(user1)
      question2.vote_down(user1)
      question3.vote_up(user1)
      question3.vote_up(user2)
    end

    scenario 'ordered by vote sum' do
      visit most_voted_questions_path

      expect(question3.title).to appear_before(question1.title)
      expect(question1.title).to appear_before(question2.title)
    end
  end

  context 'Featured questions' do
    # scenario 'with Bounty ordered by Bounty size' do
    #   visit question_path(question1)
    #   visit popular_questions_path

    #   expect(question1.title).to appear_before(question2.title)
    # end
  end
end