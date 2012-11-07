class PersistedPerson < ActiveRecord::Base
  
  self.table_name = "people"
  
  has_many :todos, class_name: PersistedTodo.to_s, foreign_key: :person_id
  
end