require 'spec_helper'

describe SearchController do

  describe "GET 'search'" do
    let!(:question1) { create(:question,
      body: 'Невероятно сложный вопрос, который надо решить') }
    let!(:question2) { create(:question,
      body: 'Довольно сложный вопрос, который надо решить') }
    let!(:question3) { create(:question,
      body: 'Очень простой вопрос, который надо решить') }

    context "when results found" do
      before {  }

      it "assigns records containing search text to @results" do
        ThinkingSphinx::Test.index
        get :search, q: 'сложный'
        expect(assigns(:results)).to eq([question1, question2])
      end

      it "renders :search view" do
        get :search, q: 'сложный'
        expect(response).to render_template 'search'
      end
    end

    context "when results not found" do
      it "@results are empty" do
        ThinkingSphinx::Test.index
        get :search, q: 'не найдено'
        expect(assigns(:results)).to be_empty
      end

      it "renders :search view" do
        get :search, q: 'не найдено'
        expect(response).to render_template 'search'
      end
    end
  end
end
