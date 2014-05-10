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
      assign :question, build(:question)
    end

    it "displays Answer count" do
      render
      expect(rendered).to have_selector 'h3', '0 ответов'
    end

    it "displays new Answer label field" do
      render
      expect(rendered).to have_selector 'form#answer h2', 'Ваш ответ'
    end

    it "displays new Answer form field" do
      render
      expect(rendered).to have_selector(
        'form#answer textarea[name="answer[body]"]')
    end

    it "displays new Answer form field" do
      render
      expect(rendered).to have_selector 'input[type=submit]',
        'Отправить ваш ответ'
    end
  end
end