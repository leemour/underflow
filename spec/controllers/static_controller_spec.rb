require 'spec_helper'

describe StaticController do
  describe "GET #index" do
    before { get :index }

    it { should render_template('index') }
  end

  describe "GET #help" do
    before { get :help }

    it { should render_template('help') }
  end

  describe "Routing" do
    it { should route(:get, '/').to('static#index') }
    it { should route(:get, '/help').to('static#help') }
  end
end