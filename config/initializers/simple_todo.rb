if "true" == ENV["IN_MEMORY"]
  SimpleTodo::Repository.configuration(
    :person => SimpleTodo::Repository::InMemory::PersonRepository.new
  )
else
  require './lib/repository/active_record/person_repository.rb'
  SimpleTodo::Repository.configuration(
    :person => Repository::ActiveRecord::PersonRepository.new
  )
end