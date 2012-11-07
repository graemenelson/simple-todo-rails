require './test/test_helper'

class TodosControllerTest < ActionController::TestCase

  Todo = SimpleTodo::Entity::Todo

  test "#index without an authenticated person" do
    get :index
    assert_redirected_to new_sessions_path
  end
  
  test "#index with an authenticated person with no todos" do
    person = create_person( uuid:  SecureRandom.uuid )
    sign_in( person )
    get :index
    assert_response :ok
    assert_template :index
    assert assigns(:todo), "should assign a new todo form object"
    assert assigns(:todos), "should assign a list of todo items for current person"
  end
  
  test "#create without an authenticated person" do
    post :create, todo: { title: "my title" }
    assert_redirected_to new_sessions_path
  end
  
  test "#create with an authenticated person, and invalid todo" do
    person = create_person
    sign_in( person )
    post :create, todo: {}
    assert_response :ok
    assert_template :index
    assert assigns(:todo), "should return the todo form object"
    todos = assigns(:todos)
    assert todos, "should assign a list of todo items for current person"
    assert todos.empty?, "should not add a new todo"
  end
  
  test "#create with an authenticated person, and valid todo" do
    person = create_person
    sign_in( person )
    post :create, todo: { title: "my todo" }
    assert_redirected_to todos_path
    person = SimpleTodo::Repository.for( :person ).find_by_uuid( person.uuid )
    assert_equal 1, person.todos.size, "person should have one todo"
  end
  
  test "#completed without an authenticated person" do
    post :completed, id: SecureRandom.uuid
    assert_redirected_to new_sessions_path
  end
  
  test "#completed with an authenticated person but invalid uuid" do
    todo = Todo.new( uuid: "someuuid" )
    person = create_person
    person.add_todo( todo )
    sign_in( person )
    post :completed, id: SecureRandom.uuid
    assert_redirected_to todos_path
    assert person.todos.include?( todo ), "person should still have todo"
    assert_nil todo.completed_at, "todo should not have a completed at time"
  end
  
  test "#completed with authenticated person and valid uuid" do
    todo = Todo.new( uuid: SecureRandom.uuid )
    person = create_person
    person.add_todo( todo )
    SimpleTodo::Repository.for( :person ).save( person )
    sign_in( person )
    post :completed, id: todo.uuid
    assert_redirected_to todos_path
    person = SimpleTodo::Repository.for( :person ).find_by_uuid( person.uuid )
    todo   = person.todos.first
    assert_equal 1, person.todos.size, "person should have 1 todo"
    assert todo.completed?, "todo should be completed"
  end

end
