require './test/helpers/form_test_helper'

describe Forms::NewTodo do
  
  before do
    @interactor = MiniTest::Mock.new
  end
  
  describe "#new" do
    
    describe "with no parameters" do
      
      subject { Forms::NewTodo.new( @interactor) }
      
      it "should return a nil title" do
        subject.title.must_be_nil
      end
      
    end
    
  end
  
  describe "#save" do
        
    describe "with no attributes" do
      
      subject { Forms::NewTodo.new( @interactor ) }
      
      it "should have errors on title" do
        subject.save.must_equal( false )
        subject.errors[:title].wont_be_empty
      end
          
    end
    
    describe "with nil title attribute" do
      
      subject { Forms::NewTodo.new( @interactor, { title: nil } ) }
      
      before do
        @result = subject.save
      end
      
      it "must return a false result" do
        @result.must_equal( false )
      end      
      
      it "should have an error on title" do
        subject.errors[:title].wont_be_empty
      end
      
      it "should not assign a todo" do
        subject.todo.must_be_nil
      end
      
    end
    
    describe "with blank title attribute" do
      
      subject { Forms::NewTodo.new( @interactory, { title: "" } ) }
      
      before do
        @result = subject.save
      end
      
      it "must return a false result" do
        @result.must_equal( false )
      end
            
      it "should have an error on title" do
        subject.errors[:title].wont_be_empty
      end
      
      it "should not assign todo" do
        subject.todo.must_be_nil
      end
      
    end
    
    describe "with title attribute" do
      
      subject { Forms::NewTodo.new( @interactor, {title: "my first todo"} ) }
      
      describe "with @interactor returning an errored response" do
        
        before do
          @errors   = { title: ["is not valid"] }
          @response = OpenStruct.new( errors?: true, errors: @errors )
          @interactor.expect( :call, @response, [{ title: "my first todo" }] )
          @result = subject.save
        end
        
        it "should call all the expected methods on the @interactor" do
          @interactor.verify
        end
        
        it "should assign error messages to title" do
          subject.errors[:title].wont_be_empty          
        end
        
      end
      
      describe "with @interactor returning a successful response" do
        
        before do
          @todo    = OpenStruct.new
          @response = OpenStruct.new( errors?: false )
          @interactor.expect( :call, @response, [{ title: "my first todo" }])
          @interactor.expect( :todo, @todo )
          @result = subject.save
        end
        
        it "should call all the expected methods on the @interactor" do
          @interactor.verify
        end
        
        it "should not have any errors" do
          subject.errors.must_be_empty
        end
        
        it "should assign todo" do
          subject.todo.must_equal( @todo )
        end
        
      end
      
    end
    
    
  end
  
end