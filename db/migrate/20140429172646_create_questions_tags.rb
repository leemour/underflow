class CreateQuestionsTags < ActiveRecord::Migration
  def change
    create_table :questions_tags, id: false do |t|
      t.references :question, index: true
      t.references :tag, index: true
    end
  end
end
