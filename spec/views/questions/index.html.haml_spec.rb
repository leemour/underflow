require 'spec_helper'

describe 'questions/index.html.haml' do
  it "displays all Questions titles" do
    assign :questions, [
      create(:question, title: 'First Question title'),
      create(:question, title: 'Second Question title')
    ]
    render
    expect(rendered).to have_selector 'h3 a', text: 'First Question title'
    expect(rendered).to have_selector 'h3 a', text: 'Second Question title'
  end

  it "displays Question's time created ago" do
    question = create(:question)
    assign :questions, [question]
    render
    expect(rendered).to have_selector '.question time'
  end

  it "displays Question author name" do
    user = create(:user)
    question = create(:question, user: user)
    assign :questions, [question]
    render
    expect(rendered).to have_selector '.question .author', text: user.name
  end
end