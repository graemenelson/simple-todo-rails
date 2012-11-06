class ApplicationController < ActionController::Base

  class NotAuthenticated < StandardError; end

  protect_from_forgery
  
  helper_method :logged_in?
  def logged_in?
    current_person.present?
  end
  
  def current_person
    return @current_person if @current_person
    find_person = SimpleTodo::Interactors::FindPerson.new( SimpleTodo::Repository.for(:person) )
    response = find_person.call( uuid: session[:uuid] )
    @current_person = response.errors? ? nil : find_person.person
  end
  
  def current_person=(person)
    uuid = person ? person.uuid : nil
    session[:uuid] = uuid
  end
  
  def current_person_uuid
    current_person ? current_person.uuid : nil
  end
  
  def authenticated!
    redirect_to new_sessions_path and return false unless current_person
  end
  
  def person_repository
    SimpleTodo::Repository.for(:person )
  end
  
end
