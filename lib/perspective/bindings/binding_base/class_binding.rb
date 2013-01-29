
module ::Perspective::Bindings::BindingBase::ClassBinding

  include ::Perspective::Bindings::BindingBase
    
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique

  ################
  #  initialize  #
  ################

  def initialize( bound_container, binding_name, ancestor_binding = nil, & configuration_proc )

    @__bound_container__ = bound_container

    if ancestor_binding
      @__parent_binding__ = ancestor_binding
      ::CascadingConfiguration.register_parent( self, ancestor_binding )
      __initialize_route__
    else
      __initialize_defaults__( binding_name )
    end

    if block_given?
      __configure__( & configuration_proc )
    end
    
  end

  #############################
  #  __initialize_defaults__  #
  #############################

  def __initialize_defaults__( binding_name )

    __binding_name_validates__?( binding_name )

    self.__name__ = binding_name

    __initialize_route__    
    
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
  
end
