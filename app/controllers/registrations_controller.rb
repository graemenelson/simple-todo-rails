class RegistrationsController < ApplicationController
  def new
    @registration = Forms::NewRegistration.new( add_person_interactor )
  end
  
  
  def create
    @registration = Forms::NewRegistration.new( add_person_interactor, params[:registration] )
    if @registration.save
      self.current_person = @registration.person
      flash[:notice]
      redirect_to todos_path
    else
      render :new
    end
  end
  
  private
  
  def add_person_interactor
    @add_person_interactory ||= SimpleTodo::Interactors::AddPerson.new( person_repository )
  end
  
  
end
