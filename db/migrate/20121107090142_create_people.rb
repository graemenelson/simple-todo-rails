class CreatePeople < ActiveRecord::Migration
  def up
    create_table :people do |t|
      t.string :uuid, :email, :salt, :encrypted_password
      t.timestamps
    end
  end

  def down
    drop_table :people
  end
end
