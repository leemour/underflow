class AddBestToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :accepted, :boolean, default: false, index: true
  end
end
