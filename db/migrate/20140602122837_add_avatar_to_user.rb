class AddAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    remove_column :profiles, :avatar, :string
  end
end
