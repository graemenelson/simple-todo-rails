require './test/test_helper'
require './lib/repository/active_record/person_repository'

module Repository
  module ActiveRecord
    class PersonRepositoryTest < ActiveSupport::TestCase
      
      setup do
        @repository       = Repository::ActiveRecord::PersonRepository.new
        @valid_attributes = { uuid: SecureRandom.uuid, email: "sam@somwehere.com", salt: "mysalt", encrypted_password: "aklajdlfjdf" }
      end
      
      test "#save with a new SimpleTodo::Entity::Person and no todos" do
        person      = SimpleTodo::Entity::Person.new( @valid_attributes )
        assert_equal 0, @repository.count, "there should be no persited people yet"
        result      = @repository.save( person )
        assert_equal 1, @repository.count, "should have created a new persisted person"
        assert_equal person, result
      end
      
      test "#save with a new SimpleTodo::Entity::Person with todos" do
        person = SimpleTodo::Entity::Person.new( @valid_attributes )
        todo_1 = SimpleTodo::Entity::Todo.new( uuid: SecureRandom.uuid, title: "my first todo" )
        todo_2 = SimpleTodo::Entity::Todo.new( uuid: SecureRandom.uuid, title: "my second todo" )        
        person.add_todo( todo_1 )
        person.add_todo( todo_2 )
        assert_equal 2, person.todos.size
        result = @repository.save( person )
        assert_equal 1, @repository.count
        assert_equal person, result
        
        persisted_person = PersistedPerson.first
        assert_equal person.uuid, persisted_person.uuid
        assert_equal 2, persisted_person.todos.size, "persisted person should have 2 persisted todos"
      end
      
      test "#save with an existing SimpleTodo::Entity::Person with no todos" do
        persisted_person    = PersistedPerson.create( @valid_attributes )
        initial_updated_at  = persisted_person.updated_at
        assert initial_updated_at, "should have an updated set on persisted person"
        assert_equal 1, @repository.count
        person = SimpleTodo::Entity::Person.new( @valid_attributes.merge( salt: "changed" ) ) # need to change something, so updated_at gets updated
        result = @repository.save( person )
        assert_equal 1, @repository.count, "should not add a new record"
        assert initial_updated_at != persisted_person.reload.updated_at, "updated at should be updated"
        assert_equal result, person        
      end
      
      test "#save with an existing SimpleTodo::Entity::Person with todos" do
        persisted_person = PersistedPerson.create( @valid_attributes )
        assert persisted_person.todos.empty?, "there should be no exisitng tods on persisted person"
        assert_equal 1, @repository.count, "there should be only one person in the repository"
        
        person = @repository.find_by_email( @valid_attributes[:email] )
        assert person.is_a?( SimpleTodo::Entity::Person ), "should return a SimpleTodo::Entity::Person"
        
        todo_1 = SimpleTodo::Entity::Todo.new( uuid: SecureRandom.uuid, title: "my first todo" )
        todo_2 = SimpleTodo::Entity::Todo.new( uuid: SecureRandom.uuid, title: "my second todo" )        
        person.add_todo( todo_1 )
        person.add_todo( todo_2 )
        
        @repository.save( person )
        assert_equal 1, @repository.count, "there shoud still only one person" 
        assert_equal 2, persisted_person.reload.todos.size, "there should be 2 persisted todos on persisted person"
      end
      
      test "#find_by_email with no existing person" do
        assert_nil @repository.find_by_email("noone@thisaddress.com"), "should not return a person"
      end
      
      test "#find_by_email with existing person with no todos" do
        PersistedPerson.create( @valid_attributes )
        person = @repository.find_by_email( @valid_attributes[:email] )
        assert person.is_a?( SimpleTodo::Entity::Person )
        assert_equal @valid_attributes[:uuid], person.uuid
        assert_equal @valid_attributes[:email], person.email
        assert_equal @valid_attributes[:salt], person.salt
        assert_equal @valid_attributes[:encrypted_password], person.encrypted_password
        assert person.todos.empty?, "should have no todos on person"
      end
      
      test "#find_by_email with existing person with todos" do
        persisted_person = PersistedPerson.create( @valid_attributes )
        persisted_todo_1 = persisted_person.todos.create( uuid: SecureRandom.uuid, title: "my first todo" )
        persisted_todo_2 = persisted_person.todos.create( uuid: SecureRandom.uuid, title: "a completed todo", completed_at: 2.days.ago )
        assert_equal 2, persisted_person.reload.todos.size, "persisted person should have 2 persisted todos"
        
        person = @repository.find_by_email( @valid_attributes[:email] )
        assert person.is_a?( SimpleTodo::Entity::Person )
        assert_equal 2, person.todos.size, "person should have 2 todos"
        assert !person.todos.first.completed?
        assert person.todos.last.completed?
      end
      
      test "#find_by_uuid with no existing person" do
        assert_nil @repository.find_by_uuid("lajdlfkajdlfjsd"), "should not return a person"
      end
      
      test "#find_by_uuid with existing person with no todos" do
        PersistedPerson.create( @valid_attributes )
        person = @repository.find_by_uuid( @valid_attributes[:uuid] )
        assert person.is_a?( SimpleTodo::Entity::Person )
        assert_equal @valid_attributes[:uuid], person.uuid
        assert_equal @valid_attributes[:email], person.email
        assert_equal @valid_attributes[:salt], person.salt
        assert_equal @valid_attributes[:encrypted_password], person.encrypted_password
        assert person.todos.empty?, "should have no todos on person"        
      end
      
      test "#exists? with no person with given email" do
        assert !@repository.exists?( {email: "noone@somehwere.com" })
      end
      
      test "#exists? with a person with a given email" do
        PersistedPerson.create( @valid_attributes )
        assert @repository.exists?( {email: @valid_attributes[:email]} )
      end
      
    end
  end
end