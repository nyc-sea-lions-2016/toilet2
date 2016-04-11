class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true, unique:true
      t.string :password_digest, null: false, index: true
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :zip_code, null: false
      t.string :gender, null: false

      t.timestamps null: false
    end
  end
end
