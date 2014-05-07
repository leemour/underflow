require 'spec_helper'

describe QuestionsController do
  describe "Routing" do
    it { should route(:get, questions_path).to   'questions#index'}
    it { should route(:get, question_path(1)).to 'questions#show', id: '1'}
    it { should route(:get, new_question_path).to 'questions#new'}
    it { should route(:get, edit_question_path(1)).to 'questions#edit', id: '1'}
    it { should route(:post, questions_path).to  'questions#create' }
    it { should route(:patch, question_path(1)).to  'questions#update', id: '1'}
    it { should route(:delete, question_path(1)).to  'questions#destroy', id: '1'}
  end

  describe "GET #index" do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it "assigns all Questions to @questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders :index view" do
      expect(response).to render_template 'index'
    end
  end

  describe "GET #show" do
    subject { create(:question) }
    before { get :show, id: subject }

    it "assigns requested Question to @question" do
      expect(assigns(:question)).to eq(subject)
    end

    it "renders :show view" do
      expect(response).to render_template 'show'
    end
  end

  describe "GET #new" do
    before do
      login_user
      get :new
    end

    it "assigns new Question to @question" do
      expect(assigns(:question)).to be_a_new Question
    end

    it "renders :new view" do
      expect(response).to render_template 'new'
    end
  end

  describe "GET #edit" do
    subject { create(:question) }
    before do
      login_user
      get :edit, id: subject
    end

    it "finds Question for edit" do
      expect(assigns(:question)).to eq(subject)
    end

    it { should render_template 'edit' }
  end

  describe "POST #create" do
    before { login_user }

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
    before { login_user }

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
    before { login_user }

    it "finds Question to delete" do
      delete :destroy, id: question
      expect(assigns(:question)).to eq(question)
    end

    it "deletes the requested Question" do
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
