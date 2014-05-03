require 'spec_helper'

describe 'questions/index.html.haml' do
  it "displays all Questions titles" do
    questions = []
    questions << create(:question, title: 'First Question title')
    questions << create(:question, title: 'Second Question title')
    assign :questions, questions
    render
    expect(rendered).to have_selector 'h3 a', text: 'First Question title'
    expect(rendered).to have_selector 'h3 a', text: 'Second Question title'
  end

  it "displays Question's time created ago" do
    question = create(:question)
    assign :questions, [question]
    render
    expect(rendered).to have_selector '.question .time',
      text: created_ago(question)
  end
end