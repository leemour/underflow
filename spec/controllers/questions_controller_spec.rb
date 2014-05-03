require 'spec_helper'

describe QuestionsController do
  describe "Routing" do
    it { should route(:get, questions_path).to   'questions#index' }
    it { should route(:get, question_path(1)).to 'questions#show', id: '1' }
    it { should route(:post, questions_path).to  'questions#create' }
  end

  describe "GET #index" do
    it "assigns all Questions to @questions" do
      questions = create_list(:question, 3)
      get :index
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders :index view" do
      get :index
      expect(response).to render_template 'index'
    end
  end

  describe "GET #show" do
    subject { create(:question) }

    it "assigns Question with requested id to @question" do
      question = create(:question)
      get :show, id: question
      expect(assigns(:question)).to eq(question)
    end

    it "renders :show view" do
      question = create(:question)
      get :show, id: question
      expect(response).to render_template 'show'
    end
  end

  describe "GET #new" do
    before { get :new }

    it "assigns new Question to @question" do
      expect(assigns(:question)).to be_a_new Question
    end

    it { should render_template 'new' }
  end

  describe "GET #edit" do
    subject { create(:question) }
    before { get :edit, id: subject }

    it "finds Question for edit" do
      expect(assigns(:question)).to eq(subject)
    end

    it { should render_template 'edit' }
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves new Question to DB" do
        expect{
          post :create, question: attributes_for(:question)
        }.to change(Question, :count).by(1)
      end

      it "redirects to new Question" do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to Question.last
      end
    end

    context "with invalid attributes" do
      it "doesn't save new Question to DB" do
        expect{
          post :create, question: {title: 'invalid'}
        }.to_not change(Question, :count)
      end

      it "reneders :new view" do
        post :create, question: {title: 'invalid'}
        expect(response).to render_template 'new'
      end
    end
  end

  describe "PATCH #update" do
    subject { create(:question, title: 'Not updated title') }

    context "with valid attributes" do
      before do
        patch :update, id: subject,
          question: attributes_for(:question, title: 'Updated title!!')
      end

      it "finds Question for update" do
        expect(assigns(:question)).to eq(subject)
      end

      it "changes @question attributes" do
        subject.reload
        expect(subject.title).to eq('Updated title!!')
      end

      it "redirects to the updated Question" do
        expect(response).to redirect_to subject
      end
    end

    context "with invalid attributes" do
      before do
        patch :update, id: subject,
          question: attributes_for(:question, title: 'Too short')
      end

      it "finds Question for update" do
        expect(assigns(:question)).to eq(subject)
      end

      it "doesn't change @question attributes" do
        subject.reload
        expect(subject.title).to eq('Not updated title')
      end

      it "re-renders :edit view" do
        expect(response).to render_template 'edit'
      end
    end
  end

  describe "DELETE destroy" do
    let!(:question) { create(:question) }

    it "finds Question to delete" do
      delete :destroy, id: question
      expect(assigns(:question)).to eq(question)
    end

    it "deletes the Question with requested id" do
      expect{
        delete :destroy, id: question
      }.to change(Question, :count).by(-1)
    end

    it "redirects to question index" do
      delete :destroy, id: question
      expect(response).to redirect_to questions_path
    end
  end
end
