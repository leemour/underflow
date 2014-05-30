require 'spec_helper'

describe 'questions/show.html.haml' do
  before { assign :answer, build(:answer) }
  before { assign :comment, build(:comment) }

  it "displays Question title" do
    assign :question, create(:question, title: 'Question display title')
    render
    expect(rendered).to have_selector 'h1', text: 'Question display title'
  end

  it "displays Question body" do
    assign :question, create(:question,
      body: 'How to build a Ruby on Rails app in 1 second? I have no idea')
    render
    expect(rendered).to have_content(
      'How to build a Ruby on Rails app in 1 second? I have no idea')
  end

  context 'when Question has Tags' do
    it 'displays links of Question Tags ' do
      tag = create(:tag, name: 'Ruby on Rails')
      assign :question, create(:question, tags: [tag])
      render
      expect(rendered).to have_link 'Ruby on Rails', href: tag_path(tag)
    end
  end

  context 'when Question has an Answer' do
    it 'displays Answer body ' do
      answer = create(:answer,
        body: 'This is very easy indeed. Just press the button. Just do it!')
      assign :question, create(:question, answers: [answer])
      render
      expect(rendered).to have_selector '.answer-text',
        'This is very easy indeed. Just press the button. Just do it!'
    end
  end

  describe 'Answer part' do
    before do
      assign :question, create(:question)
      assign :answer, build(:answer)
    end

    it "displays Answer count" do
      render
      expect(rendered).to have_selector 'h3', '0 ответов'
    end

    it "displays new Answer label field" do
      render
      expect(rendered).to have_selector 'h2', 'Ваш ответ'
    end

    it "displays new Answer form field" do
      render
      expect(rendered).to have_selector '#answer_body'
    end

    it "displays new Answer form field" do
      render
      expect(rendered).to have_selector 'input[type=submit]',
        'Отправить ваш ответ'
    end
  end
end