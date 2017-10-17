class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :age
      t.string :name
      t.integer :mother_id
      t.integer :father_id
      t.integer :tribe_id

      t.timestamps null: false
    end
  end
end
