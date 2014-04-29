class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.text :excerpt
      t.text :body

      t.timestamps
    end
  end
end
