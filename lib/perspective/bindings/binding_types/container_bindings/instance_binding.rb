
module ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
  
  include ::CascadingConfiguration::Setting
  include ::Perspective::Bindings::Container::Configuration
  include ::Perspective::Bindings::Container::ObjectAndBindingInstance
  
  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding, bound_container_instance )
        
    super
    
    __initialize_container_from_class__

  end
  
  #########################################
  #  __initialize_container_from_class__  #
  #########################################
  
  def __initialize_container_from_class__( container_class = @__parent_binding__.__container_class__ )
    
    container_instance = nil
    
    if container_class
      __extend__( container_class::Controller::InstanceBindingMethods )
      container_instance = container_class.new_nested_instance( self )
      # :__store_initialized_container_instance__ is used instead of :__container__= 
      # so that we can store without any overloaded effects.
      __store_initialized_container_instance__( container_instance )
    end
    
    return container_instance
    
  end
  
  #############################
  #  __initialize_bindings__  #
  #############################
  
  def __initialize_bindings__
    
    __container__
    
    __bindings__.each do |this_binding_name, this_binding|
      this_binding.__initialize_bindings__
    end
    
  end
  
  #############################
  #  __configure_container__  #
  #############################
  
  def __configure_container__( bound_container = __bound_container__ )
      
    # run configuration proc for each binding instance
		@__parent_binding__.__configuration_procs__.each do |this_configuration_proc|
      bound_container.__instance_exec__( self, & this_configuration_proc )
	  end
	  
    __bindings__.each do |this_binding_name, this_binding|
      this_binding.__configure_container__
    end
	  
	  return self
    
  end

  ########################
  #  __has_container__?  #
  ########################
  
  def __has_container__?
    
    return __container__( true ) ? true : false
    
  end
  
  ###################
  #  __container__  #
  ###################

  attr_instance_configuration  :__container__

  def __container__( do_not_initialize = false )
    
    container_instance = nil

    unless do_not_initialize or container_instance = super()
      if container_class = @__parent_binding__.__container_class__
        container_instance = __initialize_container_from_class__
      end
    end
    
    return container_instance
    
  end

  ##############################################
  #  __store_initialized_container_instance__  #
  ##############################################
  
  alias_method :__store_initialized_container_instance__, :__container__=
  
  ####################
  #  __container__=  #
  ####################

  def __container__=( container_instance )
    
    super

    if container_instance
      
      instance_binding_methods_class = nil
      case container_instance
        when ::Perspective::Bindings::Container::MultiContainerProxy
          if container_instance.count > 0
            instance_binding_methods_class = container_instance[0].class
          end
        else
          instance_binding_methods_class = container_instance.class
      end

      __extend__( instance_binding_methods_class::Controller::InstanceBindingMethods )
    
      # Normal inheritance when container class is defined on class binding is
      # Class Instance => Class Binding => Instance Binding => Container Instance.
      # When container instance is instead provided to instance binding then inheritance is
      # Class Instance => Container Instance => Instance Binding
      #
      #
      # FIX - we probably need to make this replace the config values instead of replace parent
      ::CascadingConfiguration.replace_parent( self, @__parent_binding__, container_instance )
      
    end
    
  end

  ###############
  #  container  #
  ###############

  Controller.alias_instance_method( :container, :__container__ )

  alias_method( :container, :__container__ )

  ################
  #  container=  #
  ################

  alias_method( :container=, :__container__= )

  ################
  #  __value__=  #
  ################

  def __value__=( object )
        
    __autobind__( @__value__ )

    # even if we have an array we store it in @__value__
    # we call super after autobinding to prevent storage if we have an array but multiple not permitted
    super

    return object
    
  end

  ############
  #  value=  #
  ############

  alias_method  :value=, :__value__=

  ##################
  #  __autobind__  #
  ##################
  
  def __autobind__( data_object )
    
    case data_object
      when ::Array
        __autobind_array__( data_object )
      when ::Hash
        __autobind_hash__( data_object )
      else
        __autobind_object__( data_object )
    end
    
    return self
    
  end

  ##############
  #  autobind  #
  ##############
  
  alias_method  :autobind, :__autobind__
  
  #########################
  #  __autobind_object__  #
  #########################

  def __autobind_object__( data_object )

    if container = __container__
      container.__autobind__( data_object )
    end

    return self
    
  end

  ########################
  #  __autobind_array__  #
  ########################

  def __autobind_array__( data_array )

    unless __permits_multiple__?
      raise ::ArgumentError, "Received array when multiple not permitted for " << container.to_s << '.' 
    end
    
    case autobind_item_count = data_array.size
      when 0
        # empty array, do nothing
      when 1
        # bind as normal object - no reason to treat as list
        __autobind_object__( data_array[ 0 ] )
      else
        # list maps to multiple containers
        __ensure_multi_container_proxy__.
        __ensure_container_count__( autobind_item_count ).
        __autobind__( data_array )
    end
    
    return self
    
  end

  #######################
  #  __autobind_hash__  #
  #######################
  
  def __autobind_hash__( data_hash )
    
    if container = __container__
      __container__.__autobind_hash__( data_hash )
    end

    return self
    
  end

  ######################################
  #  __ensure_multi_container_proxy__  #
  ######################################
  
  def __ensure_multi_container_proxy__
    
    multi_container_proxy = __container__
    
    unless ::Perspective::Bindings::Container::MultiContainerProxy === multi_container_proxy
      multi_container_proxy = ::Perspective::Bindings::Container::MultiContainerProxy.new( self )
      self.__store_initialized_container_instance__( multi_container_proxy )
    end
    
    return multi_container_proxy
    
  end

end
