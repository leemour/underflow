class RenameBodyToDescriptionInTags < ActiveRecord::Migration
  def change
    rename_column :tags, :body, :description
  end
end
