class AddReputationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reputation, :integer, default: 0, null: false
  end
end
