
module ::Magnets::Bindings::ClassBinding::Interface

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique

  ccm = ::CascadingConfiguration::Methods

  ################
  #  initialize  #
  ################

  def initialize( bound_container, 
                  binding_name,
                  container_class = nil, 
                  ancestor_binding = nil,
                  & configuration_proc )

    case bound_container

      when ::Magnets::Bindings::Container::ClassInstance

        @__bound_container_class__ = bound_container
        @__bound_container__ = bound_container
      
      when ::Magnets::Bindings::ClassBinding
      
        @__parent_binding__ = bound_container
        @__bound_container__ = bound_container
        @__bound_container_class__ = bound_container.__container_class__
        
    end

    if ancestor_binding

      __initialize_ancestor_configuration__( ancestor_binding )

      if container_class
        __validate_container_class__( container_class )
        self.__container_class__ = container_class
      end

    else

      __initialize_defaults__( binding_name, container_class )

    end

    if container_class or container_class = __container_class__
      extend( container_class::ClassBindingMethods )
    end

    __initialize_route__( bound_container )

    if block_given?
      __configure__( & configuration_proc )
    end
    
  end

  #############################
  #  binding_name_validates?  #
  #############################

  def binding_name_validates?( binding_name )
  
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

  def __initialize_defaults__( binding_name, container_class )
    
    ::CascadingConfiguration::Variable.register_child_for_parent( self, self.class )

    binding_name_validates?( binding_name )

    if container_class
      __validate_container_class__( container_class )
      self.__container_class__ = container_class
      extend( container_class::ClassBindingMethods )
      ::CascadingConfiguration::Variable.register_child_for_parent( self, container_class )
    end
    
    self.__name__ = binding_name
    self.__required__ = false    

  end

  ##########################
  #  __initialize_route__  #
  ##########################
  
  def __initialize_route__( bound_container )
    
    self.__route_with_name__ = route_with_name = [ __name__ ]
    self.__route_string__ = route_string = ::Magnets::Bindings.context_string( route_with_name )
    self.__route_print_string__ = ::Magnets::Bindings.context_print_string( route_string )
    
  end
  
  ###########################################
  #  __initialize_ancestor_configuration__  #
  ###########################################
  
  def __initialize_ancestor_configuration__( ancestor_binding = nil )
    
    ::CascadingConfiguration::Variable.register_child_for_parent( self, ancestor_binding )

  end

  ###############################
  #  bound_container_class      #
  #  __bound_container_class__  #
  #  bound_container            #
  #  __bound_container__        #
  ###############################

  attr_reader  :__bound_container_class__
  
  alias_method  :bound_container_class, :__bound_container_class__
      
  #########################
  #  container_class      #
  #  __container_class__  #
  #########################

  attr_configuration  :__container_class__

  ccm.alias_module_and_instance_methods( self, :container_class, :__container_class__ )

end
