# -*- encoding : utf-8 -*-

module ::Perspective::BindingTypes::ContainerBindings::ClassBinding

  include ::CascadingConfiguration::Setting
  include ::Perspective::Bindings::Container::Configuration
  include ::Perspective::Bindings::Container::ObjectAndBindingInstance
  
  ####################################
  #  initialize«new_between_common»  #
  ####################################

  def initialize«new_between_common»( binding_name, container_class = nil )
    
    super( binding_name )
    
    if container_class
      «validate_container_class»( container_class )
      self.«container_class» = container_class
    end
    
  end

  #################################
  #  initialize«common_finalize»  #
  #################################

  def initialize«common_finalize»
    
    super

    initialize«container_class_support»
    
  end
  
  #########################################
  #  initialize«container_class_support»  #
  #########################################
  
  def initialize«container_class_support»

    if container_class = «container_class»
      extend( container_class::Controller::ClassBindingMethods )
      unless ::CascadingConfiguration.is_parent?( self, container_class )
        # if we have a parent binding then it has already registered the container class as a parent
        # and we have already registered it as our parent, so we don't want to replace it
        ::CascadingConfiguration.register_parent( self, container_class, :singleton_to_instance )
      end
    end
  
  end

  ################################
  #  «validate_container_class»  #
  ################################

  def «validate_container_class»( container_class )
    	  
		unless container_class.respond_to?( :«bindings» )
  		raise ::Perspective::Bindings::Exception::ContainerClassLacksBindings,
  		        'Class ' + container_class.to_s + ' was declared as a container class, ' +
  		        'but does not respond to :' + :«bindings».to_s + '.'
	  end
    
  end

  #######################
  #  «container_class»  # 
  #######################

  attr_configuration  :«container_class»

  ########################
  #  «container_class»=  #
  ########################

  def «container_class»=( container_class )
    
    «validate_container_class»( container_class )
    
    return super
    
  end

  #####################
  #  container_class  #
  #####################

  self::Controller.alias_module_and_instance_methods( :container_class, :«container_class» )

  ######################
  #  container_class=  #
  ######################

  self::Controller.alias_module_and_instance_methods( :container_class=, :«container_class»= )
  
  ####################
  #  «nested_route»  # 
  ####################
  
  ###
  # Get route to binding (self) from parent container where self is nested.
  #   Assumes that both bindings share a common root.
  #
  def «nested_route»( nested_in_container )

    nested_route = nil
    
    # our route: <root>-route-to-binding
    # nested route: <root>-route-to-binding-nested-in-self
    # result desired: nested-in-self
    
    if nested_in_container.is_root?
      nested_route = «route»
    else
      slice_off_start_route = nested_in_container.«route_with_name»
      slice_size = slice_off_start_route.size
      route_from_root = «route»
      route_from_root_size = route_from_root.size
      remaining_route_size = route_from_root_size - slice_size
      if remaining_route_size > 0
        nested_route = «route».slice( slice_size, remaining_route_size )
      end
    end
    
    return nested_route
    
  end
  
end
