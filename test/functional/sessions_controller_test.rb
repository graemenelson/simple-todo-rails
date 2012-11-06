require './test/test_helper'

class SessionsControllerTest < ActionController::TestCase

  test "#create with invalid credentials" do
    post :create, session: { email: "blah", password: "password" }
    assert flash[:error]
    assert_redirected_to new_sessions_path
  end
  
  test "#create with valid credentials" do
    person = create_person( email: "jim@somewhere.com", password: "mypassword" )
    sign_in( person )
    post :create, session: { email: "jim@somewhere.com", password: "mypassword" }
    assert_redirected_to todos_path
  end
  
  test "#destroy without an authenticated person" do
    delete :destroy
    assert_redirected_to new_sessions_path
  end
  
  test "#destroy with authenticated person" do
    person = create_person
    sign_in( person )
    delete :destroy
    assert flash[:message]
    assert_redirected_to new_sessions_path
  end

end
