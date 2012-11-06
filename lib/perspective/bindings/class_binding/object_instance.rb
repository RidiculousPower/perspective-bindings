
module ::Perspective::Bindings::ClassBinding::ObjectInstance

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique

  ################
  #  initialize  #
  ################

  def initialize( bound_container, 
                  binding_name,
                  container_class = nil, 
                  ancestor_binding = nil,
                  & configuration_proc )

    @__bound_container__ = bound_container

    if ancestor_binding

      ::CascadingConfiguration.register_parent( self, ancestor_binding )

      __initialize_route__

      __initialize_for_container_class__( container_class )
      
    else

      __initialize_defaults__( binding_name, container_class )

    end

    if block_given?
      __configure__( & configuration_proc )
    end
    
  end

  ################
  #  __extend__  #
  ################
  
  ###
  # Original #extend method for extending this class binding instance. Renamed to permit
  #   #extend to be used for configuring corresponding instance bindings.
  #
  alias_method( :__extend__, :extend )

  ###########################
  #  __extension_modules__  #
  ###########################

  attr_unique_array :__extension_modules__
  
  ############
  #  extend  #
  ############
  
  ###
  # Cause instance bindings corresponding to this class binding to be extended by provided module(s).
  #  
  def extend( *modules )
    
    # Store the modules somewhere so that instances can use them.
    # We keep youngest first so that we can extend( *__extension_modules__ ) later.
    __extension_modules__.unshift( *modules )
  
  end

  #################################
  #  __binding_name_validates__?  #
  #################################

  def __binding_name_validates__?( binding_name )
  
    if ::Perspective::Bindings::ProhibitedNames.has_key?( binding_name.to_sym )
      raise ::ArgumentError, 'Cannot declare :' + binding_name.to_s + ' as a binding - ' +
                             'prohibited for verbosity, since resulting errors are often not ' + 
                             'self-explanatory and therefore very difficult to debug.'
    end
  
  end
  
  ##################################
  #  __validate_container_class__  #
  ##################################

  def __validate_container_class__( container_class )
    	  
		unless container_class.respond_to?( :__bindings__ )
  		raise ::Perspective::Bindings::Exception::ContainerClassLacksBindings,
  		        'Class ' + container_class.to_s + ' was declared as a container class, ' +
  		        'but does not respond to :' + :__bindings__.to_s + '.'
	  end
    
  end

  #############################
  #  __initialize_defaults__  #
  #############################

  def __initialize_defaults__( binding_name, container_class )
    
    self.__name__ = binding_name
    self.__required__ = false
    
    __initialize_route__
    
    ::CascadingConfiguration.register_parent( self, self.class )

    __binding_name_validates__?( binding_name )
    
    __initialize_for_container_class__( container_class )
    
  end
  
  ########################################
  #  __initialize_for_container_class__  #
  ########################################
  
  def __initialize_for_container_class__( container_class )
  
    if container_class or container_class = __container_class__
    
      __validate_container_class__( container_class )

      self.__container_class__ = container_class

      __extend__( container_class::Controller::ClassBindingMethods )

      ::CascadingConfiguration.register_parent( self, container_class )

    end
  
  end

  ##########################
  #  __initialize_route__  #
  ##########################
  
  def __initialize_route__

    @__root__ = @__bound_container__.__root__
    
    self.__route_with_name__ = route_with_name = [ __name__ ]
    self.__route_string__ = route_string = ::Perspective::Bindings.context_string( route_with_name )
    self.__route_print_string__ = ::Perspective::Bindings.context_print_string( @__root__, route_string )
    
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

  Controller.alias_module_and_instance_methods( :container_class, :__container_class__ )
  
end
