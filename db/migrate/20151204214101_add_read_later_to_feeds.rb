class AddReadLaterToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :read_later, :boolean, default: false, null: false
  end
end
