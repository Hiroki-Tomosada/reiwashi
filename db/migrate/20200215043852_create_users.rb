class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string    :name
      t.string    :email
      t.string    :sex
      t.datetime  :birthday
      t.string    :place
      t.string    :password_digest

      t.timestamps
    end
  end
end
