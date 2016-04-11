class ToiletsTable < ActiveRecord::Migration
  def change
    create_table :toilets do |t|
    	t.string :name, null: false
    	t.string :location, null: false
      t.string :zip_code
      t.string :neighborhood
      t.string :sublocality
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
