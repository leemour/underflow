class CreateBounties < ActiveRecord::Migration
  def change
    create_table :bounties do |t|
      t.references :question, index: true
      t.references :winner, index: true
      t.integer :value
    end
  end
end
