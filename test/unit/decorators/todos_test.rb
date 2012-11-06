require './test/helpers/decorator_test_helper'

describe Decorators::Todos do
  
  before do
    @interactor = MiniTest::Mock.new
  end
  
  describe "#new" do
  
    describe "with no attributes" do
      
      subject { Decorators::Todos.new( @interactor ) }
      
      describe "paginator" do
        
        before do
          @paginator = subject.paginator
        end
        
        it "should be on page 1" do
          @paginator.page.must_equal( 1 )
        end
        
        it "should have a page size of 10" do
          @paginator.page_size.must_equal( 10 )
        end
        
      end
          
    end
    
    describe "with page and page_size attributes" do
      
      subject { Decorators::Todos.new( @interactor, { page: 2, page_size: 20 } ) }
      
      describe "paginator" do
        
        before do
          @paginator = subject.paginator
        end
        
        it "should be on page 2" do
          @paginator.page.must_equal( 2 )
        end
        
        it "should have a page size of 20" do
          @paginator.page_size.must_equal( 20 )
        end
        
      end
      
    end
    
  end
  
end