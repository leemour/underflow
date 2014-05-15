class RemoveColumnsFromUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.remove :real_name, :website, :location, :birthday, :about
    end
  end
end
