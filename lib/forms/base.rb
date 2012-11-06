module Forms
  class Base

    include Virtus

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    # initializes a form object with the given interactor
    # and attributes.
    def initialize(interactor, attributes = {})
      @interactor = interactor
      (attributes||{}).each do |attribute, value|
        send("#{attribute}=", value) if respond_to?(attribute.to_sym)
      end
    end
    
    # forms are never persisted.
    def persisted?
      false
    end
    
    def save
      if valid?
        save!
        true
      else
        false
      end
    end
    
   private
   
   attr_reader :interactor
   
   # the subclass implements this method, to handle calling the
   # appropriate supporting classes to actually to the save and
   # to set attributes on itself.
   def save!
     fail NotImplementedError, "subclasses must implement this"
   end 
    
   # takes the errors from the response, and assigns
   # them to the instance errors.
   def assign_errors_from_response( response )
     response.errors.each do |key, value|
       value.each do |message|
         errors[key.to_sym] = message 
       end
     end     
   end
    
  end
end