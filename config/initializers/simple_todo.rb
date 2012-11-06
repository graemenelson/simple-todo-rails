SimpleTodo::Repository.configuration(
  :person => SimpleTodo::Repository::InMemory::PersonRepository.new
)