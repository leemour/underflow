require 'spec_helper'

describe QuestionsController do
  describe "Routing" do
    it { should route(:get, '/').to   'questions#index'}
    it { should route(:get, question_path(1)).to 'questions#show', id: '1'}
    it { should route(:get, new_question_path).to 'questions#new'}
    it { should route(:get, edit_question_path(1)).to 'questions#edit', id: '1'}
    it { should route(:post, questions_path).to  'questions#create' }
    it { should route(:patch, question_path(1)).to  'questions#update', id: '1'}
    it { should route(:delete, question_path(1)).to  'questions#destroy', id: '1'}
  end

  describe "GET #favor" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when logged in' do
      before { login_user }
      before { get :favor, id: question }

      it "redirects to question" do
        expect(response).to redirect_to(question)
      end
    end

    context 'when not logged in' do
      it "renders :index view" do
        get :favor, id: question
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #favorited" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 3) }
    before do
      questions.each do |question|
        create(:favorite, favorable: question, user: user)
      end
      get :favorited, user_id: user
    end

    it "assigns user Questions to @questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders :favorited view" do
      expect(response).to render_template 'favorited'
    end
  end

  describe "GET #tagged" do
    let(:tag1) { create(:tag) }
    let(:tag2) { create(:tag) }
    let(:question1) { create(:question, tag_list: [tag1.name]) }
    let(:question2) { create(:question, tag_list: [tag1.name, tag2.name]) }
    let(:question3) { create(:question, tag_list: [tag2.name]) }

    before { get :tagged, tag_id: tag1 }

    it "assigns user Questions to @questions" do
      expect(assigns(:questions)).to match_array [question1, question2]
    end

    it "renders :tagged view" do
      expect(response).to render_template 'tagged'
    end
  end

  describe "GET #voted" do
    let(:user) { create(:user) }
    let(:question1) { create(:question) }
    let(:question2) { create(:question) }
    let(:question3) { create(:question) }

    before do
      create(:vote, voteable: question1, user: user)
      create(:vote, voteable: question2, user: user)
      get :voted, user_id: user
    end

    it "assigns user Questions to @questions" do
      expect(assigns(:questions)).to match_array [question1, question2]
    end

    it "renders :voted view" do
      expect(response).to render_template 'voted'
    end
  end

  describe "GET #by_user" do
    let(:user) { create(:user) }
    let(:questions) { create_list(:question, 3, user: user) }
    before { get :by_user, user_id: user }

    it "assigns user Questions to @questions" do
      expect(assigns(:questions)).to match_array(questions)
    end

    it "renders :index view" do
      expect(response).to render_template 'by_user'
    end
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
    subject { create(:question, user: @user) }
    before do
      login_user
      get :edit, id: subject
    end

    it "finds Question to edit" do
      expect(assigns(:question)).to eq(subject)
    end

    it { should render_template 'edit' }
  end

  describe "POST #create" do
    before { login_user }

    context "with valid attributes" do
      it "saves new Question to DB" do
        expect {
          post :create, question: attributes_for(:question)
        }.to change(@user.questions, :count).by(1)
      end

      it "redirects to new Question" do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to Question.last
      end
    end

    context "with invalid attributes" do
      it "doesn't save new Question to DB" do
        expect {
          post :create, question: {title: 'invalid'}
        }.to_not change(@user.questions, :count)
      end

      it "reneders :new view" do
        post :create, question: {title: 'invalid'}
        expect(response).to render_template 'new'
      end
    end
  end

  describe "PATCH #update" do
    before { login_user }
    subject { create(:question, user: @user, title: 'Not updated title') }

    context "with valid attributes" do
      context "with AJAX" do
        before do
          patch :update, id: subject, format: :js,
            question: attributes_for(:question, title: 'Updated title!!')
        end

        it "finds Question for update" do
          expect(assigns(:question)).to eq(subject)
        end

        it "changes @question title" do
          subject.reload
          expect(subject.title).to eq('Updated title!!')
        end

        it "redirects to the updated Question" do
          expect(response).to render_template 'update'
        end
      end

      context "without AJAX" do
        before do
          patch :update, id: subject,
            question: attributes_for(:question, title: 'Updated title!!')
        end

        it "finds Question for update" do
          expect(assigns(:question)).to eq(subject)
        end

        it "changes @question title" do
          subject.reload
          expect(subject.title).to eq('Updated title!!')
        end

        it "redirects to the updated Question" do
          expect(response).to redirect_to subject
        end
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

    context "when not user's Question" do
      let!(:alien_question) { create(:question, user: create(:user),
          title: 'Not updated title') }

      it "doesn't change @question attributes" do
        patch :update, id: alien_question,
          question: attributes_for(:question, title: 'Not allowed to change title')
        alien_question.reload

        expect(alien_question.title).to eq('Not updated title')
      end

      it "responds with 403 status" do
        patch :update, id: alien_question,
          question: attributes_for(:question, title: 'Not allowed to change title')
        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE #destroy" do
    context 'when not logged in' do
      let!(:question) { create(:question) }

      it "doesn't delete Question from DB" do
        expect {
          delete :destroy, id: question
        }.to_not change(Question, :count)
      end

      it "redirects to login path" do
        delete :destroy, id: question
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when own Question' do
      before { login_user }
      let!(:question) { create(:question, user: @user) }

      it "finds Question to delete" do
        delete :destroy, id: question
        expect(assigns(:question)).to eq(question)
      end

      it "deletes the Question from DB" do
        expect {
          delete :destroy, id: question
        }.to change(@user.questions, :count).by(-1)
      end

      it "redirects to question index" do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
      end
    end

    context "when not user's Question" do
      before { login_user }
      let!(:alien_question) { create(:question, user: create(:user)) }

      it "doesn't delete Question from DB" do
        expect {
          delete :destroy, id: alien_question
        }.to_not change(Question, :count)
      end

      it "responds with 403 status" do
        delete :destroy, id: alien_question
        expect(response.status).to eq(403)
      end
    end
  end
end
