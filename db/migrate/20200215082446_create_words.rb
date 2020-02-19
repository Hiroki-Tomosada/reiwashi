class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.string  :name
      t.integer :user_id
      t.integer :tag_id
      t.string  :sex
      t.date    :birthday
      t.string  :place

      t.timestamps
    end
  end
end
