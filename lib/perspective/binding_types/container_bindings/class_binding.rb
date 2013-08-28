# -*- encoding : utf-8 -*-

module ::Perspective::BindingTypes::ContainerBindings::ClassBinding

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
  
  def initialize«container_class_support»( container_class = «container_class» )

    if container_class
      extend( container_class::ClassBindingMethods )
      ::CascadingConfiguration.register_singleton_to_instance( self, container_class )
    end
  
  end

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
      nested_route = «route».slice( slice_size, remaining_route_size ) if remaining_route_size > 0
    end
    
    return nested_route
    
  end
  
end
