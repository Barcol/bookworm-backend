class CreateReadings < ActiveRecord::Migration[7.1]
  def change
    create_table :readings do |t|
      t.references :book, null: false, foreign_key: true
      t.datetime :start_date
      t.integer :start_page
      t.datetime :end_date
      t.integer :end_page

      t.timestamps
    end
  end
end
