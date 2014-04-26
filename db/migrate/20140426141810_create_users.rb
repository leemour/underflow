class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :real_name
      t.string :website
      t.string :location
      t.datetime :birthday
      t.text :about

      t.timestamps
    end
  end
end
