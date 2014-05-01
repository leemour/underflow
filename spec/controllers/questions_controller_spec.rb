require 'spec_helper'

describe QuestionsController do
  describe "Routing" do
    it { should route(:get, questions_path).to('questions#index') }
    it { should route(:get, question_path(1)).to('questions#show', id: '1') }
    it { should route(:post, questions_path).to('questions#create') }
  end

  describe "GET #index" do
    before { get :index }

    it { should render_template('index') }

    it "assigns all questions to @questions" do
      question1 = create(:question)
      question2 = create(:question)
      expect(assigns(:questions)).to include(question1, question2)
    end
  end

  describe "GET #show" do
    before { get :show, id: 1 }

    it { should render_template('show') }

    it "assigns question with requested id to @question" do
      question1 = create(:question, id: 3)
      # TODO: Error - key already exists
      # question2 = create(:question, id: 1)
      expect(assigns(:question).id).to eq(1)
    end
  end

  describe "POST #create" do
    it "creates a new contact" do
      expect{
        post :create, question: attributes_for(:question)
      }.to change(Question, :count).by(1)
    end

    context "with valid attributes" do
      it "redirects to new question" do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to Question.last
      end
    end

    # it "redirects to new_quesetion_path unless created" do
    #   post :create, question: {title: 'hi'}
    #   expect(response).to redirect_to new_question_path
    # end
  end
end
