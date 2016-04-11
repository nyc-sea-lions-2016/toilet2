class FavoritesTable < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
    	t.belongs_to :favoriter, null: false, index: true
    	t.belongs_to :toilet, null: false, index: true

      t.timestamps null: false
    end
  end
end
