module Forms
  
  class NewTodo < Base
    
    attr_reader :todo
    
    # attributes for form
    attribute :title, String
    
    validates :title, presence: true
    
    private
    
    def save!  
      response = interactor.call( title: title )
      unless response.errors?
        @todo = interactor.todo
      else
        assign_errors_from_response( response )
      end    
    end
    
  end
end