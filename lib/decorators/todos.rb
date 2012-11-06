module Decorators
  class Todos
    
    attr_reader :paginator
      
    def initialize( interactor, attributes = {} )
      @interactor = interactor
      @paginator  = setup_paginator( attributes )  
    end
    
    private
    
    attr_reader :interactor
    
    def setup_paginator( attributes = {} )
      page      = attributes.fetch(:page, 1)
      page_size = attributes.fetch(:page_size, 10)
      OpenStruct.new( page: page, page_size: page_size )      
    end
    
  end
end