module Repository
  module ActiveRecord
    class PersonRepository
   
      # saves the given SimpleTodo::Entity::Person to the 
      # database as PersistedPerson.
      def save(person)
        return false unless person
        attributes = { uuid: person.uuid, email: person.email, salt: person.salt, encrypted_password: person.encrypted_password }
        if persisted_person = PersistedPerson.find_by_uuid( attributes[:uuid] )
          persisted_person.update_attributes( attributes )
        else      
          persisted_person = PersistedPerson.create( attributes )
        end        
        persist_todos( persisted_person, person.todos )
        person
      end
      
      # looks up a persisted person by email, if found
      # returns a SimpleTodo::Entity::Person.
      def find_by_email(email)
        persisted_person = PersistedPerson.find_by_email( email )
        return nil unless persisted_person
        person_from_persisted_person( persisted_person )
      end
      
      # looks up a persisted person by uuid, if found
      # returns a SimpleTodo::Entity::Person.
      def find_by_uuid( uuid )
        persisted_person = PersistedPerson.find_by_uuid( uuid )
        return nil unless persisted_person
        person_from_persisted_person( persisted_person )
      end
      
      def exists?( attributes = {} )
        found = find_by_email( attributes[:email] )
        found ? true : false
      end
      
      def count
        PersistedPerson.count
      end
      
      def clear
        PersistedPerson.destroy_all
      end
      
      
      private
      
      def person_from_persisted_person( persisted_person )
        person = SimpleTodo::Entity::Person.new( persisted_person.attributes.symbolize_keys.slice(:uuid, :email, :salt, :encrypted_password) )
        persisted_person.todos.each do |persisted_todo|
          person.add_todo( todo_from_persisted_todo( persisted_todo ) )
        end
        person
      end
      
      def todo_from_persisted_todo( persisted_todo )
        SimpleTodo::Entity::Todo.new( persisted_todo.attributes.symbolize_keys.slice(:uuid, :title, :completed_at) )
      end
      
      def persist_todos( persisted_person, todos = [] )
        todos.each do |todo|
          persist_todo( persisted_person, todo )
        end
      end
      
      def persist_todo( persisted_person, todo )
        return unless todo.uuid.present?
        attributes = { uuid: todo.uuid, title: todo.title, completed_at: todo.completed_at }
        if todo = persisted_person.todos.find_by_uuid( todo.uuid )
          todo.update_attributes( attributes )
        else
          persisted_person.todos.create( attributes )
        end
      end
      
    end
  end
end