class CreateCountries < ActiveRecord::Migration[8.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :capital
      t.string :region
      t.integer :population

      t.timestamps
    end
  end
end
