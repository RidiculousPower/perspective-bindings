
module ::Magnets::Bindings::ClassBinding::Initialization

  ################
  #  initialize  #
  ################

  def initialize( binding_name, 
                  container_class = nil, 
                  ancestor_binding = nil,
                  base_route = nil, 
                  & configuration_proc )

    if ancestor_binding

      __initialize_ancestor_configuration__( ancestor_binding )

      if base_route
        __initialize_route__( base_route )
      end

      if container_class
        __validate_container_class__( container_class )
        self.__container_class__ = container_class
      end

    else

      __initialize_defaults__( binding_name, container_class, base_route )

    end

    if container_class or container_class = __container_class__
      extend( container_class::ClassBindingMethods )
    end

    if block_given?
      __configure__( & configuration_proc )
    end
    
  end

  ###############################
  #  __validate_binding_name__  #
  ###############################

  def __validate_binding_name__( binding_name )
  
    if ::Magnets::Bindings::ProhibitedNames.has_key?( binding_name.to_sym )
      raise ::ArgumentError, 'Cannot declare :' + binding_name.to_s + ' as a binding - ' +
                             'prohibited to prevent errors that are very difficult to debug.'
    end
  
  end
  
  ##################################
  #  __validate_container_class__  #
  ##################################

  def __validate_container_class__( container_class )
    	  
		unless container_class.respond_to?( :__bindings__ )
  		raise ::Magnets::Bindings::Exception::ContainerClassLacksBindings,
  		        'Class ' + container_class.to_s + ' was declared as a container class, ' +
  		        'but does not respond to :' + :__bindings__.to_s + '.'
	  end
    
  end

  #############################
  #  __initialize_defaults__  #
  #############################

  def __initialize_defaults__( binding_name, container_class, base_route )
    
    ::CascadingConfiguration::Variable.register_child_for_parent( self, self.class )

    __validate_binding_name__( binding_name )

    if container_class
      __validate_container_class__( container_class )
      self.__container_class__ = container_class
      extend( container_class::ClassBindingMethods )
      ::CascadingConfiguration::Variable.register_child_for_parent( self, container_class )
    end
    
    self.__name__ = binding_name
    self.__required__ = false    

    __initialize_route__( base_route )
    
  end

  ##########################
  #  __initialize_route__  #
  ##########################
  
  def __initialize_route__( base_route )
    
    route_string = nil
    
    if base_route
      self.__route__ = base_route
      route_string = base_route.join( ::Magnets::Bindings::RouteDelimiter )
      route_string << ::Magnets::Bindings::RouteDelimiter
    else
      route_string = ''
    end
    
    route_string << __name__.to_s
    
    self.__route_string__ = route_string
    
  end
  
  ###########################################
  #  __initialize_ancestor_configuration__  #
  ###########################################
  
  def __initialize_ancestor_configuration__( ancestor_binding = nil )
    
    ::CascadingConfiguration::Variable.register_child_for_parent( self, ancestor_binding )

  end
    
end
