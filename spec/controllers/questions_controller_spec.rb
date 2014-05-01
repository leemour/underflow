require 'spec_helper'

describe QuestionsController do
  describe "GET #index" do
    before { get :index }

    it { should render_template('index') }
  end

  describe "GET #show" do
    before { get :show, 1 }

    # it { should render_template('show') }
  end

  describe "Routing" do
    it { should route(:get, questions_path).to('questions#index') }
    it { should route(:get, question_path(1)).to('questions#show') }
  end
end
