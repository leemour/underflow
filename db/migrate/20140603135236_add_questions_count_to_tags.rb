class AddQuestionsCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :questions_count, :integer, default: 0, null: false
  end
end
