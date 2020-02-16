class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string  :name
      t.string  :email
      t.string  :sex
      t.integer :age
      t.string  :place

      t.timestamps
    end
  end
end
