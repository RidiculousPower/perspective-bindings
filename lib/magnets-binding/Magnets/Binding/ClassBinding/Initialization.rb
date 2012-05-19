
module ::Magnets::Binding::ClassBinding::Initialization

  ################
  #  initialize  #
  ################

  def initialize( binding_name, 
                  view_class = nil, 
                  ancestor_binding = nil,
                  base_route = nil, 
                  & configuration_proc )

    if ancestor_binding

      __initialize_ancestor_configuration__( ancestor_binding )

      if base_route
        __initialize_route__( base_route )
      end

      if view_class
        __validate_view_class__( view_class )
        self.__view_class__ = view_class
      end    

    else

      __initialize_defaults__( binding_name, view_class, base_route )

    end

    if block_given?
      __configure__( & configuration_proc )
    end
        
  end

  ###############################
  #  __validate_binding_name__  #
  ###############################

  def __validate_binding_name__( binding_name )
  
    if ::Magnets::Binding::Container::ProhibitedNames.has_key?( binding_name.to_sym )
      raise ::ArgumentError, 'Cannot declare :' + binding_name.to_s + ' as a binding - ' +
                             'prohibited to prevent errors that are very difficult to debug.'
    end
  
  end
  
  #############################
  #  __validate_view_class__  #
  #############################

  def __validate_view_class__( view_class )
    	  
	  if view_class

      unless view_class.method_defined?( :to_html_node )     or 
             view_class.method_defined?( :to_html_fragment )

        raise ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError,
                'View class specified (' + view_class.to_s + ') does not respond to either ' +
                ':to_html_node or :to_html_fragment.'
      end
      
    end
    
  end

  #############################
  #  __initialize_defaults__  #
  #############################

  def __initialize_defaults__( binding_name, view_class, base_route )
    
    ::CascadingConfiguration::Variable.register_child_for_parent( self, self.class )

    __validate_binding_name__( binding_name )
    __validate_view_class__( view_class )
    
    self.__name__ = binding_name
    self.__view_class__ = view_class
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
      route_string = base_route.join( ::Magnets::Binding::Container::RouteDelimiter )
      route_string << ::Magnets::Binding::Container::RouteDelimiter
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
    
    if ancestor_binding

      ::CascadingConfiguration::Variable.register_child_for_parent( self, ancestor_binding )
    
    end

  end
    
end
