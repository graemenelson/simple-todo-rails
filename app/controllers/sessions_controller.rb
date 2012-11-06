class SessionsController < ApplicationController
  
  before_filter :authenticated!, :except => [:create, :new]
  
  def new
  end
  
  def create
    # Could have used a Forms object for logging in, but it seemed a little overkill
    response = authenticate_person_interactor.call( params[:session] )
    if response.errors?
      flash[:error] = "Sorry, the email address and/or password was invalid."
      redirect_to new_sessions_path
    else
      self.current_person = authenticate_person_interactor.person
      redirect_to todos_path
    end
  end
  
  def destroy
    if current_person
      self.current_person = nil
      flash[:message] = "Good-bye, see you next time!"
    end
    redirect_to new_sessions_path
  end
  
  private
  
  def authenticate_person_interactor
    @authenticate_person_interactor ||= SimpleTodo::Interactors::AuthenticatePerson.new( person_repository )
  end
  
end
