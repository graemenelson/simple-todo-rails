ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  
  setup do
    SimpleTodo::Repository.for( :person ).clear
  end
  
  def sign_in(person)
    session[:uuid] = person.uuid
  end
  
  def create_person(attributes = {})
    add_person_interactor = SimpleTodo::Interactors::AddPerson.new( person_repository, SimpleTodo::Encryptors::BCrypt.new( ::BCrypt::Password, 1 ) )
    valid_attributes = { email: "jim@somewhere.com", password: "mypassword" }
    response = add_person_interactor.call( valid_attributes.merge( attributes ) )
    unless response.errors?
      add_person_interactor.person
    else
      raise ArgumentError, "issue creating person: #{response.errors.inspect}"
    end
  end
  
  def person_repository
    SimpleTodo::Repository.for( :person )
  end
  
end
