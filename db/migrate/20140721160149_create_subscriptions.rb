class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :subscribable, polymorphic: true, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
