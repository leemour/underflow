require 'spec_helper'

describe 'Answers API' do
  describe 'GET #show' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        post '/api/v1/questions/1/answers', format: :json,
          answer: attributes_for(:answer), question_id: question
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        post '/api/v1/questions/1/answers', format: :json, access_token: 'abc',
          answer: attributes_for(:answer), question_id: question
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:question) { create(:question) }
      let(:access_token) { create(:access_token) }

      context 'with invalid attributes' do
        it "responds with 422 status" do
          post api_v1_question_answers_path(question), format: :json,
            answer: {body: ''}, question_id: question, access_token: access_token.token
          expect(response.status).to eq(422)
        end

        it "doesn't create new Answer" do
          expect {
            post api_v1_question_answers_path(question), format: :json,
              answer: {body: ''}, question_id: question,
              access_token: access_token.token
          }.to_not change(Answer, :count)
        end
      end

      context 'with valid attributes' do
        before do
          post api_v1_question_answers_path(question), format: :json,
            answer: attributes_for(:answer), question_id: question,
            access_token: access_token.token
        end

        it 'responds with 200 status' do
          expect(response.status).to eq(200)
        end

        it "creates new Answer" do
          expect {
            post api_v1_question_answers_path(question), format: :json,
              question_id: question, access_token: access_token.token
          }.to change(Answer, :count).by(1)
        end
      end
    end
  end

  describe 'GET #index' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        get '/api/v1/questions/1/answers', format: :json
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        get '/api/v1/questions/1/answers', format: :json, access_token: 'abc'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:comment) { create(:comment, commentable: answers[0]) }
      let(:access_token) { create(:access_token) }
      before do
        get api_v1_question_answers_path(question), format: :json,
          access_token: access_token.token
      end

      it "responds with 200 status" do
        expect(response.status).to eq(200)
      end

      it 'returns list of Answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      context 'contains' do
        %w[id question_id body created_at updated_at].each do |attr|
          it "first Answer contains #{attr}" do
            expect(response.body).to be_json_eql(
              answers[0].send(attr.to_sym).to_json).
                at_path("answers/0/#{attr}")
          end
        end

        it 'timestamp' do
          expect(response.body).to be_json_eql(
            answers.last.created_at.to_json).at_path("meta/timestamp")
        end

        context 'comments' do
          it 'included in Answer' do
            expect(response.body).to have_json_size(1).
              at_path("answers/0/comments")
          end

          %w[id body created_at updated_at].each do |attr|
            it "Comment contains #{attr}" do
              expect(response.body).to be_json_eql(
                comment.send(attr.to_sym).to_json).
                  at_path("answers/0/comments/0/#{attr}")
            end
          end
        end
      end
    end
  end

  describe 'GET #show' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        get '/api/v1/questions/1/answers/1', format: :json
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        get '/api/v1/questions/1/answers/1', format: :json, access_token: 'abc'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:comment) { create(:comment, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let(:access_token) { create(:access_token) }
      before do
        get api_v1_question_answer_path(question, answer), format: :json,
          access_token: access_token.token
      end

      it "responds with 200 status" do
        expect(response.status).to eq(200)
      end

      context 'contains' do
        %w[id question_id body created_at updated_at].each do |attr|
          it "first Answer contains #{attr}" do
            expect(response.body).to be_json_eql(
              answer.send(attr.to_sym).to_json).
                at_path("answer/#{attr}")
          end
        end

        context 'comments' do
          it 'included in Answer' do
            expect(response.body).to have_json_size(1).
              at_path("answer/comments")
          end

          %w[id body created_at updated_at].each do |attr|
            it "Comment contains #{attr}" do
              expect(response.body).to be_json_eql(
                comment.send(attr.to_sym).to_json).
                  at_path("answer/comments/0/#{attr}")
            end
          end
        end
      end

      context 'attachments' do
        it 'included in Answer' do
          expect(response.body).to have_json_size(1).
            at_path("answer/attachments")
        end

        %w[id created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              attachment.send(attr.to_sym).to_json).
                at_path("answer/attachments/0/#{attr}")
          end
        end

        it "with url" do
          expect(response.body).to be_json_eql(
            attachment.file.url.to_json).
              at_path("answer/attachments/0/file/url")
        end
      end
    end
  end
end