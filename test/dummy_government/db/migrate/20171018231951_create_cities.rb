class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :county_id

      t.timestamps null: false
    end
  end
end
