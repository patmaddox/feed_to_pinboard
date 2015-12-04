class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.text :token, null: false
      t.timestamps
    end
  end
end
