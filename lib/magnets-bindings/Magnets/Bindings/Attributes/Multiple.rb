
module ::Magnets::Bindings::Attributes::Multiple

  ################
  #  value=      #
  #  __value__=  #
  ################

  def __value__=( object )
    
    if __container__
      
      # if we have an array we want 1 corresponding container per member
      if object.is_a?( ::Array )

        object_count_minus_one = object.count - 1

        if object_count_minus_one > 0

          __initialize_container_for_multiple_values__( *object )
        
        else

          super( object[ 0 ] )
        
        end
      
      else
      
        super
      
      end
    
    else
      
      super
      
    end
    
    return object
    
  end

  alias_method :value=, :__value__=

  ##################################################
  #  __initialize_container_for_multiple_values__  #
  ##################################################

  def __initialize_container_for_multiple_values__( *objects )
      
    multiple_containers_proxy = nil
    container_class = nil
  
    multiple_containers_proxy_class = ::Magnets::Bindings::Container::MultipleContainerProxy
  
    if __container__.is_a?( multiple_containers_proxy_class )
      multiple_containers_proxy = __container__
      container_class = multiple_containers_proxy.__container_class__
    else
      # we ask the instance what class it is since that could change at runtime from
      # the class binding configuration
      container_class = __container__.class
      multiple_containers_proxy = multiple_containers_proxy_class.new( container_class )
      # we've already initialized one
      multiple_containers_proxy.__push__( __container__ )
      self.__container__ = multiple_containers_proxy
    end
  
    objects.slice( 1, object_count_minus_one ).each_with_index do |this_object, this_index|
    
      if multiple_containers_proxy.count > this_index
        this_container_instance = multiple_containers_proxy[ this_index ]
      else
        this_new_container = container_class.new
        this_new_container.__parent_binding__ = self
        # new auto-created instances are children of the first instance
        ::CascadingConfiguration::
          Variable.register_child_for_parent( this_new_container, multiple_containers_proxy[ 0 ] )
        multiple_containers_proxy.push( this_new_container )
        this_container_instance = this_new_container
      end

      this_container_instance.__autobind__( this_object )          

    end
    
    return multiple_containers_proxy
    
  end

  ##########################
  #  binding_value_valid?  #
  ##########################

  def binding_value_valid?( binding_value )

    binding_value_valid = false
    
    if binding_value.is_a?( ::Array )
      
      binding_value_valid = true
      
      # ensure each member value is valid
      binding_value.each do |this_member|
        
        break unless binding_value_valid = binding_value_valid?( this_member )
        
      end
    
    elsif defined?( super )
      
      binding_value_valid = super
          
    end
    
    return binding_value_valid
    
  end

end
