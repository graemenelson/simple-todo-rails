class TodosController < ApplicationController
  
  before_filter :authenticated!
  
  def index
    load_todos
    @todo  = Forms::NewTodo.new( add_todo_interactor )    
  end
  
  def create
    load_todos
    @todo = Forms::NewTodo.new( add_todo_interactor, params[:todo] )
    if @todo.save
      redirect_to todos_path
    else
      render :index
    end
  end
  
  def completed
    complete_todo_interactor.call( todo_uuid: params[:id] )
    redirect_to todos_path
  end
  
  private
  
  def load_todos
    list_todos_interactor.call
    @todos = list_todos_interactor.todos
  end
  
  def add_todo_interactor
    @add_todo_interactor ||= SimpleTodo::Interactors::AddTodo.new( person_repository, current_person_uuid )
  end
  
  def list_todos_interactor
    @list_todos_interactor ||= SimpleTodo::Interactors::ListTodos.new( person_repository, current_person_uuid )
  end
  
  def complete_todo_interactor
    @complete_todo_interactor ||= SimpleTodo::Interactors::CompleteTodo.new( person_repository, current_person_uuid )
  end
  
end
