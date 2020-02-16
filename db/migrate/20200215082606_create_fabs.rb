class CreateFabs < ActiveRecord::Migration[5.2]
  def change
    create_table :fabs do |t|
      t.integer :word_id
      t.integer :user_id

      t.timestamps
    end
  end
end
