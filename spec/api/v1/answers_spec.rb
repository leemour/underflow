require 'spec_helper'

describe 'Answers API' do
  describe 'PATCH #update' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        patch '/api/v1/questions/1/answers/1', format: :json,
          answer: attributes_for(:answer)
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        patch '/api/v1/questions/1/answers/1', format: :json,
          access_token: 'abc', answer: attributes_for(:answer)
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:question) { create(:question) }
      subject do
        create(:answer, body: 'Not updated body. Not updated body.',
          question: question, user: me)
      end

      context "with valid attributes" do
        before do
          patch api_v1_question_answer_path(question, subject), format: :json,
            answer: attributes_for(:answer, body: 'Updated body! Updated body! Updated body!'),
            access_token: access_token.token
        end

        it "finds Answer for update" do
          expect(assigns(:answer)).to eq(subject)
        end

        it "changes @answer body" do
          subject.reload
          expect(subject.body).to eq('Updated body! Updated body! Updated body!')
        end

        it "responds with 204 status" do
          expect(response.status).to eq(204)
        end
      end

      context "with invalid attributes" do
        before do
          patch api_v1_question_answer_path(question, subject), format: :json,
            answer: attributes_for(:answer, body: 'Too short'),
            access_token: access_token.token
        end

        it "finds Answer for update" do
          expect(assigns(:answer)).to eq(subject)
        end

        it "doesn't change @answer attributes" do
          subject.reload
          expect(subject.body).to eq('Not updated body. Not updated body.')
        end

        it "responds with 422 status" do
          expect(response.status).to eq(422)
        end
      end

      context "when not user's Question" do
        let!(:alien_answer) do
          create(:answer, question: question,
            body: 'Not updated body. Not updated body.')
        end
        before do
          patch api_v1_question_answer_path(question, alien_answer),
            answer: attributes_for(:answer, body: 'Not allowed at all to change body'),
            access_token: access_token.token, format: :json
        end

        it "doesn't change @answer attributes" do
          alien_answer.reload
          expect(alien_answer.body).to eq('Not updated body. Not updated body.')
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
        delete '/api/v1/questions/1/answers/1', format: :json
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        delete '/api/v1/questions/1/answers/1', format: :json,
          access_token: 'abc'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:question) { create(:question) }

      context 'when own Answer' do
        subject! { create(:answer, question: question, user: me) }

        it "finds Answer to delete" do
          delete api_v1_question_answer_path(question, subject), format: :json,
            access_token: access_token.token
          expect(assigns(:answer)).to eq(subject)
        end

        it "deletes the Answer from DB" do
          expect {
            delete api_v1_question_answer_path(question, subject), format: :json,
              access_token: access_token.token
          }.to change(me.answers, :count).by(-1)
        end

        it "responds with 204 status" do
          delete api_v1_question_answer_path(question, subject), format: :json,
            access_token: access_token.token
          expect(response.status).to be(204)
        end
      end

      context "when not user's Answer" do
        let!(:alien_answer) { create(:answer, question: question) }

        it "doesn't delete Answer from DB" do
          expect {
            delete api_v1_question_answer_path(question, alien_answer),
              format: :json, access_token: access_token.token
          }.to_not change(Answer, :count)
        end

        it "responds with 403 status" do
          delete api_v1_question_answer_path(question, alien_answer),
            format: :json, access_token: access_token.token
          expect(response.status).to eq(403)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        post '/api/v1/questions/1/answers', format: :json,
          answer: attributes_for(:answer), question_id: 1
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
        post '/api/v1/questions/1/answers', format: :json, access_token: 'abc',
          answer: attributes_for(:answer), question_id: 1
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:question) { create(:question) }
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      context 'with invalid attributes' do
        it "responds with 422 status" do
          post api_v1_question_answers_path(question), format: :json,
            answer: {body: ''}, question_id: question,
            access_token: access_token.token
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
        it 'responds with 201 status' do
          post api_v1_question_answers_path(question), format: :json,
            answer: attributes_for(:answer), question_id: question,
            access_token: access_token.token
          expect(response.status).to eq(201)
        end

        it "creates new Answer" do
          expect {
            post api_v1_question_answers_path(question), format: :json,
              answer: attributes_for(:answer), question_id: question,
              access_token: access_token.token
          }.to change(Answer, :count).by(1)
        end

        it 'new Answer is from current_user' do
          post api_v1_question_answers_path(question), format: :json,
              answer: attributes_for(:answer), question_id: question,
              access_token: access_token.token
          expect(Answer.last.user).to eq(me)
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