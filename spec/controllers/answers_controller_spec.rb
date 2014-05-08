require 'spec_helper'

describe AnswersController
  describe "POST #create" do
    post :create, attibutes_for(:answer)

    expect(request).to redirect_to(question_path(answer.question))
  end
end