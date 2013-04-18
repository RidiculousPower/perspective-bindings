# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::ClassBinding

  include ::Perspective::Bindings::Binding
  include ::Perspective::Bindings::Configuration::SingletonAndClassBindingInstance
  
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique
  include ::CascadingConfiguration::Hash

  extend ::Perspective::Bindings::IncludeExtend

  ################
  #  initialize  #
  ################

  def initialize( bound_container, binding_name, *args, & configuration_proc )

    super
    
    «configure»( & configuration_proc ) if block_given?

  end

  ###############################
  #  initialize«common_values»  #
  ###############################

  def initialize«common_values»( bound_container )
    
    @«bound_container» = bound_container
    @«root» = bound_container.«root»
    
  end

  ####################################
  #  initialize«new_between_common»  #
  ####################################

  def initialize«new_between_common»( binding_name )
    
    «validate_binding_name»( binding_name )
    
    self.«name» = binding_name
    
  end

  ###########################################
  #  initialize«inheriting_between_common»  #
  ###########################################

  def initialize«inheriting_between_common»( bound_container, ancestor_binding )
    
    ::CascadingConfiguration.register_parent( self, @«parent_binding» = ancestor_binding )
    
  end
  
  #################################
  #  initialize«common_finalize»  #
  #################################

  def initialize«common_finalize»
    
    «initialize_route»
    
  end
  
  ########################
  #  «initialize_route»  #
  ########################
  
  def «initialize_route»
    
    if @«bound_container».equal?( @«root» )
      route_with_name = self.«route_with_name» = [ «name» ]
    else
      base_route = self.«route» = @«bound_container».«route_with_name».dup
      route_with_name = self.«route_with_name» = base_route.dup
      route_with_name.push( «name» )
    end

    self.«route_string» = route_string = ::Perspective::Bindings.context_string( route_with_name )
    self.«route_print_string» = ::Perspective::Bindings.context_print_string( @«root», route_string )

  end

  ################
  #  «bindings»  #
  ################

	attr_instance_hash  :«bindings» do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( binding_name, binding_instance, parent_hash )

      return binding_instance.class::ClassBinding.new_inheriting_binding( configuration_instance, binding_instance )

    end
    
  end

  #############################
  #  «validate_binding_name»  #
  #############################

  def «validate_binding_name»( binding_name )
  
    if ::Perspective::Bindings::ProhibitedNames.has_key?( binding_name.to_sym )
      raise ::ArgumentError, 'Cannot declare :' + binding_name.to_s + ' as a binding - ' +
                             'prohibited since resulting errors are often not ' + 
                             'self-explanatory and therefore very difficult to debug.'
    end
  
  end
  
end
