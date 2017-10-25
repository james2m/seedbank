class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.integer :party_id

      t.timestamps null: false
    end
  end
end
