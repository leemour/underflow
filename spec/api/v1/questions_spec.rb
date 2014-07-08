require 'spec_helper'

describe 'Questions API' do
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