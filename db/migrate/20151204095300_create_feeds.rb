class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.text :url, null: false
      t.timestamps
    end
  end
end
