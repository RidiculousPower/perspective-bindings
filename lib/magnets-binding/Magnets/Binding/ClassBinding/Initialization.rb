
module ::Magnets::Binding::ClassBinding::Initialization

  ################
  #  initialize  #
  ################

  def initialize( binding_name, 
                  view_class = nil, 
                  ancestor_binding = nil,
                  base_route = nil, 
                  & configuration_proc )
    
    __validate_initialization__( binding_name, view_class )
    
    __initialize_ancestor_configuration__( binding_name, view_class, ancestor_binding )
    
    __initialize_route__( base_route, binding_name )

    if block_given?
      configure( & configuration_proc )
    end
        
  end
  
  #################################
  #  __validate_initialization__  #
  #################################

  def __validate_initialization__( binding_name, view_class )
    
    if ::Magnets::Binding::ProhibitedNames.has_key?( binding_name.to_sym )
      raise ::ArgumentError, 'Cannot declare :' + binding_name.to_s + ' as a binding - ' +
                             'prohibited to prevent errors that are very difficult to debug.'
    end
	  
	  if view_class

      unless view_class.method_defined?( :to_html_node )     or 
             view_class.method_defined?( :to_html_fragment )

        raise ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError,
                'View class specified (' + view_class.to_s + ') does not respond to either ' +
                ':to_html_node or :to_html_fragment.'
      end
      
    end
    
  end

  ##########################
  #  __initialize_route__  #
  ##########################
  
  def __initialize_route__( base_route, binding_name )
    
    route_string = nil
    
    if base_route
      self.__route__ = base_route
      route_string = base_route.join( ::Magnets::Binding::RouteDelimiter )
      route_string << ::Magnets::Binding::RouteDelimiter
    else
      route_string = ''
    end
    
    route_string << binding_name.to_s
    
    self.__route_string__ = route_string
    
  end
  
  ###########################################
  #  __initialize_ancestor_configuration__  #
  ###########################################
  
  def __initialize_ancestor_configuration__( binding_name, view_class, ancestor_binding = nil )
        
    # To set up cascading configurations we need to register our parent/child inheritance tree.
    # We already have this set up in parallel by way of the bound instances.
    # So we need to see if our bound instance has an ancestor; if it does, get our parallel
    # binding of the same name and register it as parent of self.
    
    if ancestor_binding

      ::CascadingConfiguration::Variable.register_child_for_parent( self, ancestor_binding )
      
    else
      
      ::CascadingConfiguration::Variable.register_child_for_parent( self.class, ancestor_binding )

      self.__name__ = binding_name
      self.__view_class__ = view_class
      self.__required__ = false

    end

  end
    
end
