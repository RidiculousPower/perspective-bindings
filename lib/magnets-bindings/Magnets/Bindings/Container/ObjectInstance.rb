
module ::Magnets::Bindings::Container::ObjectInstance

  include ::Magnets::Bindings::Configuration

  #######################################
  #  __initialize_for_parent_binding__  #
  #######################################
  
  def __initialize_for_parent_binding__( parent_binding )

    @__parent_binding__ = parent_binding
        
  end

  ########################
  #  parent_binding      #
  #  __parent_binding__  #
  ########################
    
  attr_reader  :__parent_binding__
  alias_method  :parent_binding, :__parent_binding__

  ##################
  #  autobind      #
  #  __autobind__  #
  ##################

  def __autobind__( data_object, method_map_hash = nil )
    
    found_a_binding = false
    
    if method_map_hash
      found_a_binding = true
    end
    
    # iterate bindings, binding each to method in data_object
    # method_map_hash permits name of method in data_object to be overridden from binding_name
    __bindings__.each do |this_binding_name, this_binding_instance|

      if method_map_hash and method_name = method_map_hash[ this_binding_name ]
        
        # if we are given false/nil instead of a method name, don't look for this binding
        next unless method_name
        
        found_a_binding = true
        this_binding_instance.__value__ = data_object.__send__( method_name )

      elsif data_object.respond_to?( this_binding_name )

        found_a_binding = true
        this_binding_instance.__value__ = data_object.__send__( this_binding_name )

      end
      
    end
    
    unless found_a_binding
      
      if respond_to?( :content )
        self.content = data_object
      else
        if method_map_hash
          raise ::Magnets::Bindings::Exception::AutobindFailed, 
                  'Data object did not respond to the name of any declared bindings in ' + 
                  self.inspect + ' or provided method map and ' + self.inspect + ' does not ' +
                  'respond to :' + :content.to_s + '.'
        else
          raise ::Magnets::Bindings::Exception::AutobindFailed, 
                  ':autobind was called on ' + self.inspect + ' but data object did not respond ' +
                  'to the name of any declared bindings in ' + self.inspect + 
                  ', no method map was provided, and ' + self.inspect + 
                  ' does not respond to :' + :content.to_s + '.'
        end
      end
      
    end
    
    return self
    
  end
  
  alias_method  :autobind, :__autobind__

end
