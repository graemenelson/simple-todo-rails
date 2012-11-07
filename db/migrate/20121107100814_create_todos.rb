class CreateTodos < ActiveRecord::Migration
  def up
    create_table :todos do |t|
      t.integer   :person_id
      t.string    :uuid, :title
      t.datetime  :completed_at
      t.timestamps
    end
    add_index :todos, :person_id
  end

  def down
    drop_table :todos
  end
end
