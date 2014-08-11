require 'spec_helper'

describe ApplicationHelper do
  describe '#class_with_id' do
    it "returns object class with id for CSS selector" do
      question = create(:question, id: 1)
      expect(class_with_id(question)).to eq('#question-1')
    end
  end

  describe "#highlight_search_terms" do
    let(:text) { "A длинный text, containging different #%3 s <> for test!ng" }

    context 'when no matches' do
      it "returns original text" do
        result = highlight_search_terms(text, 'asder3')
        expect(result).to eq text
      end
    end

    context 'when matches pattern' do
      it "wraps text in <span>" do
        result = highlight_search_terms(text, 'длинный')
        expect(result).to match '<span class="search-terms">длинный</span>'
      end
    end

    context "russian" do
      let(:text) { "Одна пожилая женщина как-то, подойдя ко мне в храме, сказала:"\
        "\"Батюшка! Не могу больше терпеть мужа! Скорей бы умереть и в Рай "\
        "попасть, чтобы только его больше не видеть\". Я ей говорю: \"Дорогая моя!"\
        " Единственная возможность для вас попасть в рай – это вместе с мужем. " }

      it "wraps text in <span>" do
        result = highlight_search_terms(text, 'батюшка')
        expect(result).to match '<span class="search-terms">Батюшка</span>'
      end
    end
  end
end