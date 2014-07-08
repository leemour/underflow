require 'spec_helper'

describe 'Questions API' do
  describe 'PATCH #update' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        patch '/api/v1/questions/1', format: :json,
          question: attributes_for(:question)
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        patch '/api/v1/questions/1', format: :json, access_token: 'abc',
          question: attributes_for(:question)
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      subject { create(:question, title: 'Not updated title', user: me) }

      context "with valid attributes" do
        before do
          patch api_v1_question_path(subject), format: :json,
            question: attributes_for(:question, title: 'Updated title!!'),
            access_token: access_token.token
        end

        it "finds Question for update" do
          expect(assigns(:question)).to eq(subject)
        end

        it "changes @question title" do
          subject.reload
          expect(subject.title).to eq('Updated title!!')
        end

        it "responds with 204 status" do
          expect(response.status).to eq(204)
        end
      end

      context "with invalid attributes" do
        before do
          patch api_v1_question_path(subject), format: :json,
            question: attributes_for(:question, title: 'Too short'),
            access_token: access_token.token
        end

        it "finds Question for update" do
          expect(assigns(:question)).to eq(subject)
        end

        it "doesn't change @question attributes" do
          subject.reload
          expect(subject.title).to eq('Not updated title')
        end

        it "responds with 422 status" do
          expect(response.status).to eq(422)
        end
      end

      context "when not user's Question" do
        let!(:alien_question) { create(:question, title: 'Not updated title') }
        before do
          patch api_v1_question_path(alien_question), format: :json,
            question: attributes_for(:question, title: 'Not allowed to change'),
            access_token: access_token.token
        end

        it "doesn't change @question attributes" do
          alien_question.reload
          expect(alien_question.title).to eq('Not updated title')
        end

        it "responds with 403 status" do
          expect(response.status).to eq(403)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        delete '/api/v1/questions/1', format: :json
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        delete '/api/v1/questions/1', format: :json, access_token: 'abc'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'when own Question' do
        let!(:question) { create(:question, user: me) }

        it "finds Question to delete" do
          delete api_v1_question_path(question), format: :json,
            access_token: access_token.token
          expect(assigns(:question)).to eq(question)
        end

        it "deletes the Question from DB" do
          expect {
            delete api_v1_question_path(question), format: :json,
              access_token: access_token.token
          }.to change(me.questions, :count).by(-1)
        end

        it "responds with 204 status" do
          delete api_v1_question_path(question), format: :json,
              access_token: access_token.token
          expect(response.status).to be(204)
        end
      end

      context "when not user's Question" do
        let!(:alien_question) { create(:question) }

        it "doesn't delete Question from DB" do
          expect {
            delete api_v1_question_path(alien_question), format: :json,
              access_token: access_token.token
          }.to_not change(Question, :count)
        end

        it "responds with 403 status" do
          delete api_v1_question_path(alien_question), format: :json,
              access_token: access_token.token
          expect(response.status).to eq(403)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        post '/api/v1/questions', format: :json,
          question: attributes_for(:question)
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        post '/api/v1/questions', format: :json, access_token: 'abc',
          question: attributes_for(:question)
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:question) { create(:question) }
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with invalid attributes' do
        it "responds with 422 status" do
          post api_v1_questions_path, format: :json,
            question: {body: ''}, access_token: access_token.token
          expect(response.status).to eq(422)
        end

        it "doesn't create new Question" do
          expect {
            post api_v1_questions_path, format: :json,
              question: {body: ''}, access_token: access_token.token
          }.to_not change(Question, :count)
        end
      end

      context 'with valid attributes' do
        it 'responds with 201 status' do
          post api_v1_questions_path, format: :json,
            question: attributes_for(:question),
            access_token: access_token.token
          expect(response.status).to eq(201)
        end

        it "creates new Question" do
          expect {
            post api_v1_questions_path, format: :json,
              question: attributes_for(:question),
              access_token: access_token.token
          }.to change(Question, :count).by(1)
        end

        it 'new Question is from current_user' do
          post api_v1_questions_path, format: :json,
              question: attributes_for(:question),
              access_token: access_token.token
          expect(Question.last.user).to eq(me)
        end
      end
    end
  end

  describe 'GET #index' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        get '/api/v1/questions', format: :json, access_token: 'abc'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let!(:answer) { create(:answer, question: questions[1]) }
      let(:access_token) { create(:access_token) }
      before do
        get "/api/v1/questions", format: :json, access_token: access_token.token
      end

      it "responds with 200 status" do
        expect(response.status).to eq(200)
      end

      it 'returns list of Questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      context 'contains' do
        %w[id title body created_at updated_at].each do |attr|
          it "first Question contains #{attr}" do
            expect(response.body).to be_json_eql(
              questions[1].send(attr.to_sym).to_json).
                at_path("questions/0/#{attr}")
          end
        end

        it 'timestamp' do
          expect(response.body).to be_json_eql(
            questions.last.created_at.to_json).at_path("meta/timestamp")
        end
      end

      context 'answers' do
        it 'included in Question' do
          expect(response.body).to have_json_size(1).
            at_path("questions/0/answers")
        end

        %w[id body created_at updated_at].each do |attr|
          it "Answer contains #{attr}" do
            expect(response.body).to be_json_eql(
              answer.send(attr.to_sym).to_json).
                at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end


  describe 'GET #show' do
    let!(:question) { create(:question) }

    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        get api_v1_question_path(question), format: :json
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        get api_v1_question_path(question), format: :json, access_token: 'abc'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before do
        get api_v1_question_path(question), format: :json,
          access_token: access_token.token
      end

      it "responds with 200 status" do
        expect(response.status).to eq(200)
      end

      context 'contains' do
        %w[id title body created_at updated_at].each do |attr|
          it "Question contains #{attr}" do
            expect(response.body).to be_json_eql(
              question.send(attr.to_sym).to_json).
                at_path("question/#{attr}")
          end
        end
      end

      context 'comments' do
        it 'included in Question' do
          expect(response.body).to have_json_size(1).
            at_path("question/comments")
        end

        %w[id body created_at updated_at].each do |attr|
          it "Answer contains #{attr}" do
            expect(response.body).to be_json_eql(
              comment.send(attr.to_sym).to_json).
                at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in Question' do
          expect(response.body).to have_json_size(1).
            at_path("question/attachments")
        end

        %w[id created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              attachment.send(attr.to_sym).to_json).
                at_path("question/attachments/0/#{attr}")
          end
        end

        it "with url" do
          expect(response.body).to be_json_eql(
            attachment.file.url.to_json).
              at_path("question/attachments/0/file/url")
        end
      end
    end
  end
end