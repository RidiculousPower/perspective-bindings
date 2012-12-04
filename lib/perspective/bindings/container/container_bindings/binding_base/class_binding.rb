
module ::Perspective::View::Bindings::BindingBase::ClassBinding

  include ::Perspective::Bindings::BindingBase::ClassBinding::ObjectInstance
  include ::Perspective::View::Configuration
  include ::Perspective::View::ObjectAndBindingInstance

  ################
  #  initialize  #
  ################

  def initialize( bound_container, binding_name, container_class = nil, ancestor_binding = nil, & configuration_proc )
    
    # We want block to run after container class initializes, so we don't pass configuration_proc
    # to super. Instead we'll call at the end.
    super( bound_container, binding_name, container_class, ancestor_binding )
    
    if ancestor_binding
      __initialize_for_container_class__( container_class )
    end
    
    if block_given?
      __configure__( & configuration_proc )
    end
    
  end

  #############################
  #  __initialize_defaults__  #
  #############################

  def __initialize_defaults__( binding_name, container_class )
    
    super
    
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

  ##############################
  #  self.__container_class__  #
  ##############################

  attr_singleton_configuration  :__container_class__

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

  #####################
  #  view_class       #
  #  view_class=      #
  #  __view_class__   #
  #  __view_class__=  #
  #####################
  
  alias_method :__view_class__, :__container_class__
  alias_method :__view_class__=, :__container_class__=

  alias_method :view_class, :__view_class__
  alias_method :view_class=, :__view_class__=
  
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
