class AddAttachmentableToAttachments < ActiveRecord::Migration
  def change
    change_table :attachments do |t|
      t.integer :attachable_id, index: true
      t.string  :attachable_type, index: true
    end
  end
end
