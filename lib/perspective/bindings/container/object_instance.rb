
module ::Perspective::Bindings::Container::ObjectInstance

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::Configuration::ObjectAndBindingInstance

  include ::Perspective::Bindings::Container::ClassAndObjectInstance
  
  ##############################
  #  __initialize_for_index__  #
  ##############################
  
  def __initialize_for_index__( index )
    
    # nothing to do - implemented to permit overriding
    
  end
  
  ##############
  #  name      #
  #  __name__  #
  ##############
  
  def __name__
    
    name = nil
    
    if @__parent_binding__
      name = @__parent_binding__.__name__
    else
      name = __root_string__
    end
    
    return name
    
  end
  
  ##############
  #  root      #
  #  __root__  #
  ##############
  
  def __root__
    
    root_instance = nil
    
    if @__bound_container__
      root_instance = @__bound_container__.__root__
    else
      root_instance = self
    end
    
    return root_instance
    
  end

  alias_method  :root, :__root__

  ###############
  #  route      #
  #  __route__  #
  ###############
  
  def __route__
    
    route = nil
    
    if @__parent_binding__
      route = @__parent_binding__.__route__
    end
    
    return route
    
  end

  alias_method  :route, :__route__

  #########################
  #  route_with_name      #
  #  __route_with_name__  #
  #########################
  
  def __route_with_name__
    
    route_with_name = nil
    
    if @__parent_binding__
      route_with_name = @__parent_binding__.__route_with_name__
    end
    
    return route_with_name
    
  end

  alias_method  :route_with_name, :__route_with_name__

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
        content.__value__ = data_object
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
