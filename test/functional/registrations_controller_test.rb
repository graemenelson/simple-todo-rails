require './test/test_helper'

class RegistrationsControllerTest < ActionController::TestCase


  test "#new with no currently authenticated person" do
    get :new
    assert_template :new
    assert_not_nil  assigns(:registration)
  end
  
  test "#create with registration having errors" do
    attributes   = { email: "my@somwhere.com", password: "password", password_confirmation: "mismatch" }
    post :create, registration: attributes
    assert_template :new
    
    registration = assigns(:registration)
    assert_not_nil registration, "should have a registration"
    assert registration.errors.any?, "should have errors on registration"
    assert_nil @controller.current_person, "there should be no current person"
  end
  
  test "#create with registration with no errors" do
    attributes = { email: "sam@somewhere.com", password: "mypassword", password_confirmation: "mypassword" }
    post :create, registration: attributes
    assert @controller.current_person, "should be a current person"
    assert_redirected_to todos_path, "should redirect to todos path"
  end

end
