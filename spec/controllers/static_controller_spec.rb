require 'spec_helper'

describe StaticController do
  describe "GET #faq" do
    before { get :faq }

    it { should render_template('faq') }
  end

  describe "GET #help" do
    before { get :help }

    it { should render_template('help') }
  end

  describe "Routing" do
    it { should route(:get, '/help').to('static#help') }
  end
end