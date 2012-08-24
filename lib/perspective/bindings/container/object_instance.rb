
module ::Perspective::Bindings::Container::ObjectInstance

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::Configuration::ObjectAndBindingInstance

  include ::Perspective::Bindings::Container::ClassAndObjectInstance
  
  ##############
  #  name      #
  #  __name__  #
  ##############
  
  def __name__
    
    name = nil
    
    if @__parent_binding__
      
      name = @__parent_binding__.__name__
      
    else
      
      name = ::Perspective::Bindings::RootString
      
    end
    
    return name
    
  end
  
  #######################################
  #  __initialize_for_parent_binding__  #
  #######################################
  
  def __initialize_for_parent_binding__( parent_binding )

    @__parent_binding__ = parent_binding

  end

  ##################
  #  autobind      #
  #  __autobind__  #
  ##################

  def __autobind__( data_object, method_map_hash = nil )
    
    @__view_rendering_empty__ = false
    
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

        data_source_name = method_name

      elsif data_object.respond_to?( this_binding_name )

        found_a_binding = true
        
        data_source_name = this_binding_name
        
      end
      
      if data_source_name
        
        case data_object
        
          when ::Perspective::Bindings::Container
        
            binding_instance = data_object.__binding__( data_source_name )
            this_binding_instance.__value__ = binding_instance.__render_value__
        
          when ::Perspective::Bindings::InstanceBinding

            this_binding_instance.__value__ = data_object.__render_value__
          
          else

            this_binding_instance.__value__ = data_object.__send__( data_source_name )
        
        end
      
      end
      
    end
    
    unless found_a_binding
      
      if respond_to?( :content )
        self.content = data_object
      else
        if method_map_hash
          raise ::Perspective::Bindings::Exception::AutobindFailed, 
                  'Data object did not respond to the name of any declared bindings in ' + 
                  self.inspect + ' or provided method map and ' + self.inspect + ' does not ' +
                  'respond to :' + :content.to_s + '.'
        else
          raise ::Perspective::Bindings::Exception::AutobindFailed, 
                  ':autobind was called on ' + self.to_s + ' but data object did not respond ' +
                  'to the name of any declared bindings in ' + self.to_s + 
                  ', no method map was provided, and ' + self.to_s + 
                  ' does not respond to :' + :content.to_s + '.'
        end
      end
      
    end
    
    return self
    
  end
  
  alias_method  :autobind, :__autobind__

  ######################
  #  nested_route      #
  #  __nested_route__  #
  ######################

  def __nested_route__( nested_binding )

    nested_route = nil
    
    if @__parent_binding__
      nested_route = @__parent_binding__.__nested_route__( nested_binding )
    else
      nested_route = nested_binding.__route__
    end

    return nested_route
    
  end
  
  alias_method  :nested_route, :__nested_route__

end
