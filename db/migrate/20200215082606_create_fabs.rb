class CreateFabs < ActiveRecord::Migration[5.2]
  def change
    create_table :fabs do |t|
      t.integer :word_id
      t.integer :user_id
      t.string  :sex
      t.date    :birthday
      t.string  :place

      t.timestamps
    end
  end
end
