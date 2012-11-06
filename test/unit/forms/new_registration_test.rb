require './test/helpers/form_test_helper'

describe Forms::NewRegistration do
  
  before do
    @interactor = MiniTest::Mock.new
  end
  
  describe "#new" do
    
    describe "with no parameters" do
      
      subject { Forms::NewRegistration.new(@interactor) }
        
      it "should return a nil email address" do
        subject.email.must_be_nil
      end  
      
      it "should return a nil password" do
        subject.password.must_be_nil
      end
      
      it "should return a nil password_confirmation" do
        subject.password_confirmation.must_be_nil
      end
      
      it "should not be persisted?" do
        subject.persisted?.must_equal( false )
      end
            
    end
    
    describe "with all parameters" do
      
      subject { Forms::NewRegistration.new(@interactor, {email: "sam@somewhere.com", password: "mypassword", password_confirmation: "mypassword"}) }
      
      it "should return correct email address" do
        subject.email.must_equal( "sam@somewhere.com" )
      end
      
      it "should return correct password" do
        subject.password.must_equal( "mypassword" )
      end
      
      it "should return correct password_confirmation" do
        subject.password_confirmation.must_equal( "mypassword" )
      end
      
      it "should not be persisted?" do
        subject.persisted?.must_equal( false )
      end
      
    end
    
  end
  
  describe "#save" do
    
    describe "with no attributes" do
      
      subject { Forms::NewRegistration.new(@interactor) }
      
      before do
        @result = subject.save
      end
      
      it "should return a false result" do
        @result.must_equal( false )
      end
      
      it "should have errors on email" do
        subject.errors[:email].wont_be_empty
      end
      
      it "should have errors on password" do
        subject.errors[:password].wont_be_empty
      end
      
    end
    
    describe "with invalid email, but valid password and password confirmation" do
      
      subject { Forms::NewRegistration.new( @interactor, {email: "blah@", password: "mypassword", password_confirmation: "mypassword"} )}
      
      before do
        @result = subject.save
      end
      
      it "should return a false result" do
        @result.must_equal( false )
      end
      
      it "must have errors on email" do
        subject.errors[:email].wont_be_empty
      end      
      
      it "must not have errors on password" do
        subject.errors[:password].must_be_empty
      end
      
    end
    
    describe "with valid email and password that does not match password confirmation" do
      
      subject { Forms::NewRegistration.new( @interactor, {email: "sam@somwehere.com", password: "mypassword", password_confirmation: "doestnotmatch"} ) }
      
      before do
        @result = subject.save
      end
      
      it "should return a false result" do
        @result.must_equal( false )
      end
      
      it "should have no errors on email" do
        subject.errors[:email].must_be_empty
      end
      
      it "should have errors on password" do
        subject.errors[:password].wont_be_empty
      end
      
    end
    
    describe "with valid attributes" do
      
      subject { Forms::NewRegistration.new( @interactor, {email: "sam@somewhere.com", password: "mypassword", password_confirmation: "mypassword"}) }
       
      describe "with @interactor returning a successful response" do
        
        before do
          @entity   = OpenStruct.new
          @response = OpenStruct.new( errors?: false )
          @interactor.expect( :call, @response, [email: "sam@somewhere.com", password: "mypassword"] )
          @interactor.expect( :person, @entity )
          @result = subject.save
        end
        
        it "should call all expected methods on @interactor" do
          @interactor.verify
        end
        
        it "should assign @entity to person" do
          subject.person.must_equal( @entity )
        end
        
      end
      
      describe "with @interactor returning an errored response" do
        
        before do
          @errors   = { email: ["is already taken"] }
          @response = OpenStruct.new( errors?: true, errors: @errors )
          @interactor.expect( :call, @response, [email: "sam@somewhere.com", password: "mypassword"] )
          @result = subject.save          
        end
        
        it "should call all expected methods on @interactor" do
          @interactor.verify
        end
        
        it "should assign email errors to subject" do
          subject.errors[:email].wont_be_empty
        end
        
      end
      
    end
    
  end
  
end