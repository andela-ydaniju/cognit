class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.integer :acount_number
      t.integer :atm_pin

      t.timestamps null: false
    end
  end
end
