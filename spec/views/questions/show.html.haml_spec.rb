require 'spec_helper'

describe 'questions/show.html.haml' do
  it "displays Question title" do
    assign :question, build(:question, title: 'Question display title')
    render
    expect(rendered).to have_selector 'h1', text: 'Question display title'
  end

  it "displays Question body" do
    assign :question, build(:question,
      body: 'How to build a Ruby on Rails app in 1 second? I have no idea')
    render
    expect(rendered).to have_content(
      'How to build a Ruby on Rails app in 1 second? I have no idea')
  end

  it "displays Answer count" do
    assign :question, build(:question)
    render
    expect(rendered).to have_selector 'h3', '0 ответов'
  end

  context 'when the question has tags' do
    it 'displays links of Question Tags ' do
      tag = create(:tag, name: 'Ruby on Rails')
      assign :question, create(:question, tags: [tag])
      render
      expect(rendered).to have_link 'Ruby on Rails', href: tag_path(tag)
    end
  end
end