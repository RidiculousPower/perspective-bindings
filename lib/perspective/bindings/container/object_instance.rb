
module ::Perspective::Bindings::Container::ObjectInstance

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::Configuration::ObjectAndBindingInstance
  include ::Perspective::Bindings::Container::Configuration
  include ::Perspective::Bindings::Container::ObjectAndBindingInstance

  include ::Perspective::Bindings::Container::SingletonAndObjectInstance
  
  ##############################
  #  __initialize_for_index__  #
  ##############################
  
  def __initialize_for_index__( index )
    
    # nothing to do - implemented to permit overriding
    
  end

  #############################
  #  __initialize_bindings__  #
  #############################
  
  def __initialize_bindings__

    __bindings__.each do |this_binding_name, this_binding|
      this_binding.__initialize_bindings__
	  end
  	  
  end
  
  ##############################
  #  __configure_containers__  #
  ##############################
  
  def __configure_containers__

    __bindings__.each do |this_binding_name, this_binding|
      this_binding.__configure_container__
    end

  end

  ##################
  #  __is_root__?  #
  ##################
  
  def __is_root__?
    
    return @__bound_container__.nil?
    
  end
  
  ##############
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

  ##########
  #  root  #
  ##########

  alias_method  :root, :__root__

  #####################
  #  __root_string__  #
  #####################

  def __root_string__
    
    # [root:<instance>]
    
    root_string = nil
    
    if __root__ == self
      @__root_string__ ||= '<root:' << to_s << '>'
      root_string = @__root_string__
    else
      root_string = __root__.__root_string__
    end

    return root_string
    
  end

  ###############
  #  __route__  #
  ###############

  def __route__
    
    route = nil
    
    if @__parent_binding__
      route = @__parent_binding__.__route__
    end
    
    return route
    
  end

  ###########
  #  route  #
  ###########
  
  alias_method  :route, :__route__

  #####################
  #  route_with_name  #
  #####################

  def __route_with_name__
    
    route_with_name = nil
    
    if @__parent_binding__
      route_with_name = @__parent_binding__.__route_with_name__
    end
    
    return route_with_name
    
  end

  #########################
  #  __route_with_name__  #
  #########################
  
  alias_method  :route_with_name, :__route_with_name__

  ##################
  #  __autobind__  #
  ##################
  
  def __autobind__( data_object )
    
    @__view_rendering_empty__ = false

    found_a_binding = false
    
    case data_object
      when ::Perspective::Bindings::Container
        found_a_binding = __autobind_container__( data_object )
      when ::Perspective::Bindings::BindingBase::InstanceBinding
        found_a_binding = __autobind_binding__( data_object )
      when ::Hash
        found_a_binding = __autobind_hash__( data_object )
      else
        found_a_binding = __autobind_object__( data_object )
    end

    unless found_a_binding
      if respond_to?( :content= )
        self.content = data_object
      else
        raise ::Perspective::Bindings::Exception::AutobindFailed, 
                ':autobind was called on ' << self.to_s << ' but data object did not respond ' <<
                'to the name of any declared bindings in ' << self.to_s << 
                ', no method map was provided, and ' << self.to_s << 
                ' does not respond to :' << :content.to_s << '.'
      end
    end
    
    return self
    
  end

  ##############
  #  autobind  #
  ##############
  
  alias_method  :autobind, :__autobind__

  ############################
  #  __autobind_container__  #
  ############################

  def __autobind_container__( data_container )
    
    found_a_binding = false
    
    __bindings__.each do |this_binding_name, this_binding|
      if data_container.__has_binding__?( this_binding_name )
        this_data_binding = data_container.__binding__( this_binding_name )
        this_binding.__autobind_binding__( this_data_binding )
        found_a_binding = true
      end
    end
    
    return found_a_binding
    
  end

  ##########################
  #  __autobind_binding__  #
  ##########################

  def __autobind_binding__( data_binding )
    
    if found_a_binding = __has_binding__?( data_binding_name = data_binding.__name__ )
      __binding__( data_binding_name ).__autobind_binding__( data_binding )
    end

    return found_a_binding
    
  end
  
  #########################
  #  __autobind_object__  #
  #########################

  def __autobind_object__( data_object )
    
    found_a_binding = false

    __bindings__.each do |this_binding_name, this_binding|
      if data_object.respond_to?( this_binding_name )
        this_binding.__value__ = data_object.__send__( this_binding_name )
        found_a_binding = true
      end    
    end

    return found_a_binding
    
  end

  #######################
  #  __autobind_hash__  #
  #######################
  
  def __autobind_hash__( data_hash )

    found_a_binding = false
    
    __bindings__.each do |this_binding_name, this_binding|
      if data_hash.has_key?( this_binding_name )
        this_binding.__value__ = data_hash[ this_binding_name ]
        found_a_binding = true
      end
    end
    
    return found_a_binding
    
  end
  
  ######################
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
  
  ##################
  #  nested_route  #
  ##################
  
  alias_method  :nested_route, :__nested_route__

end
