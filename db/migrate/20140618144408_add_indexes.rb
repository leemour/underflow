class AddIndexes < ActiveRecord::Migration
  def change
    add_index :attachments, [:attachable_type, :attachable_id]
    add_index :authorizations, :user_id
    add_index :authorizations, [:provider, :uid], unique: true
  end
end
