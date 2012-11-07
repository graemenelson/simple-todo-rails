class PersistedTodo < ActiveRecord::Base
  
  self.table_name = "todos"
  
  belongs_to :person, class_name: PersistedPerson.to_s, foreign_key: :person_id
  
end