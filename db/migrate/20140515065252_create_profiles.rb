class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.string :real_name
      t.string :website
      t.string :location
      t.datetime :birthday
      t.text :about
    end
  end
end
