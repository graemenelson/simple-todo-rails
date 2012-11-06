module Forms
  class NewRegistration < Base
    
    attr_reader :person
    
    # attributes used by the form
    attribute :email, String
    attribute :password, String
    attribute :password_confirmation, String
    
    validates :email,     presence: true, email: true
    validates :password,  presence: true, confirmation: true
    
    private
    
    def save!
      response = interactor.call( {email: email, password: password} )
      unless response.errors?
        @person = interactor.person
      else
        assign_errors_from_response( response )
      end
    end
        
  end
end