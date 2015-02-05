class AddDeletedAtToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :deleted_at, :datetime
  end
end
