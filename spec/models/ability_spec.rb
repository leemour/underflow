require 'spec_helper'
require "cancan/matchers"

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    [Question, Answer, Comment].each do |resource_class|
      it { should be_able_to :read, resource_class }

      %i[create, update, destroy].each do |operate|
        it { should_not be_able_to operate, resource_class}
      end
    end
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    [Question, Answer, Comment].each do |resource_class|
      let(:resource) { create(resource_class, user: user) }
      let(:other_resource) { create(resource_class, user: other_user) }

      it { should be_able_to :create, resource_class }
      it { should be_able_to :edit, resource, user_id: user.id }
      it { should_not be_able_to :edit, other_resource, user_id: user.id }
      it { should be_able_to :update, resource, user_id: user.id }
      it { should_not be_able_to :update, other_resource, user_id: user.id }
      it { should be_able_to :destroy, resource, user_id: user.id }
      it { should_not be_able_to :destroy, other_resource, user_id: user.id }
    end

    context 'Question' do
      [:voted, :tagged, :favorited, :by_user, :favor].each do |operate|
        it { should be_able_to operate, Question }
      end
    end

    context 'Answer' do
      [:voted, :by_user].each do |operate|
        it { should be_able_to operate, Answer }
      end

      context 'accept' do
        let(:question) { create(:question, user: user) }
        let(:alien_question) { create(:question) }
        let(:answer) { create(:answer, question: question) }
        let(:alien_answer) { create(:answer, question: alien_question) }

        it { should be_able_to :accept, Answer, question: { user_id: user.id } }
        it { should be_able_to :accept, answer }
        it { should_not be_able_to :accept, alien_answer }

        context 'accepted Answer' do
          let!(:accepted_answer) { create(:answer, question: question,
          accepted: true) }
          let!(:not_accepted_answer) { create(:answer, question: question) }

          it { should be_able_to :accept, accepted_answer }
          it { should_not be_able_to :accept, not_accepted_answer }
        end
      end
    end

    context 'Bounty' do
      context 'own Question' do
        let(:question) { create(:question, user: user) }
        let(:bounty) { create(:bounty, question: question) }

        [:create, :destroy].each do |operate|
          it { should be_able_to operate, bounty }
        end
      end

      context 'other user Question' do
        let(:question) { create(:question) }
        let(:bounty) { create(:bounty, question: question) }

        [:create, :destroy].each do |operate|
          it { should_not be_able_to operate, bounty }
        end
      end
    end

    context 'User' do
      [:reset_password, :edit, :update].each do |operate|
        it { should be_able_to operate, user, id: user.id }
      end
    end

    context 'Vote' do
      let(:question) { create(:question, user: user) }
      let(:alien_question) { create(:question) }
      let(:vote) { create(:vote, voteable: question)}
      let(:alien_vote) { create(:vote, voteable: alien_question)}

      [:up, :down].each do |operate|
        it { should_not be_able_to operate, vote }
        it { should be_able_to operate, alien_vote }
      end
    end
  end
end