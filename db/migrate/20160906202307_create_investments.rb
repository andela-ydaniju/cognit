class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.string :name
      t.integer :cost
      t.string :invest_type
      t.string :long_term
      t.string :short_term

      t.timestamps null: false
    end
  end
end
