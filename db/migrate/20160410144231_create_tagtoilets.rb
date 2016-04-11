class CreateTagtoilets < ActiveRecord::Migration
  def change
    create_table :tagtoilets do |t|
  		t.references :tag, null: false
  		t.references :toilet, null: false
      t.timestamps null: false
    end
  end
end
