
module ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
  
  include ::CascadingConfiguration::Setting
  include ::Perspective::Bindings::Container::Configuration
  include ::Perspective::Bindings::Container::ObjectAndBindingInstance
  
  include ::Enumerable
  
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
      extend( container_class::Controller::InstanceBindingMethods )
      container_instance = container_class.new_nested_instance( self )
      # :__store_initialized_container_instance__ is used instead of :__container__= 
      # so that we can store without any overloaded effects.
      __store_initialized_container_instance__( container_instance )
      # if we have a value, autobind it to new container
      __autobind__( @__value__ )
    end
    
    return container_instance
    
  end
  
  #############################
  #  __initialize_bindings__  #
  #############################
  
  def __initialize_bindings__
    
    __container__
    __bindings__.each { |this_binding_name, this_binding| this_binding.__initialize_bindings__ }
    
  end
  
  #############################
  #  __configure_container__  #
  #############################
  
  def __configure_container__( bound_container = __bound_container__ )
      
    # run configuration proc for each binding instance
		@__parent_binding__.__configuration_procs__.each do |this_configuration_proc|
      bound_container.__instance_exec__( self, & this_configuration_proc )
	  end
	  
    __bindings__.each { |this_binding_name, this_binding| this_binding.__configure_container__ }
	  
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

      extend( container_instance.class::Controller::InstanceBindingMethods )
    
      # Normal inheritance when container class is defined on class binding is
      # Class Instance => Class Binding => Instance Binding => Container Instance.
      # When container instance is instead provided to instance binding then inheritance is
      # Class Instance => Container Instance => Instance Binding
      #
      #
      # FIX - we probably need to make this replace the config values instead of replace parent
      ::CascadingConfiguration.replace_parent( self, @__parent_binding__, container_instance )
      
      # if we have a value, autobind it to new container
      __autobind__( @__value__ )
      
    end
    
  end

  ###############
  #  container  #
  ###############

  alias_method( :container, :__container__ )

  ################
  #  container=  #
  ################

  alias_method( :container=, :__container__= )

  #####################################
  #  __create_additional_container__  #
  #####################################

  def __create_additional_container__( container_class = @__parent_binding__.__container_class__ )
    
    @__containers__ ||= [ ]
    
    new_container_instance = container_class.new_nested_instance( self )
    index = @__containers__.size
    @__containers__.push( new_container_instance )
    new_container_instance.__initialize_for_index__( index )

    return new_container_instance
    
  end
  
  ################################
  #  __ensure_container_count__  #
  ################################
  
  def __ensure_container_count__( container_count, container_class = @__parent_binding__.__container_class__ )

    unless container_class
      raise ::ArgumentError, 'Could not create any containers because no container class was defined or provided.'
    end
    
    case container_count
      when 1
        __container__
      else
        until @__containers__ and @__containers__.size == container_count
          __create_additional_container__( container_class )
        end
    end
    
    return self
    
  end

  ################
  #  __value__=  #
  ################

  def __value__=( data_object )

    # even if we have an array we store it in @__value__
    # we call super after autobinding to prevent storage if we have an array but multiple not permitted
    super
        
    if container = __container__
      case data_object
        when nil
          # nothing to do
        when ::Array
          __autobind_array__( data_object )
        when ::Hash
          __autobind_hash__( data_object )
        else
          __autobind_object__( data_object )
      end
    end
    
    return data_object
    
  end

  ############
  #  value=  #
  ############

  alias_method  :value=, :__value__=

  ##################
  #  __autobind__  #
  ##################
  
  alias_method :__autobind__, :__value__=

  ##############
  #  autobind  #
  ##############
  
  alias_method  :autobind, :__autobind__
  
  ########################
  #  __autobind_array__  #
  ########################

  def __autobind_array__( data_array )

    unless __permits_multiple__?
      raise ::ArgumentError, "Received array when multiple not permitted for " << container.to_s << '.' 
    end
    
    @__value__ = data_array
    
    case autobind_item_count = data_array.size
      when 0
        # empty array, do nothing
      when 1
        # bind as normal object - no reason to treat as list
        __autobind_object__( data_array[ 0 ] )
      else
        # array maps each index to each of multiple containers
        __ensure_container_count__( autobind_item_count )
        @__containers__.each { |this_container| this_container.__autobind_object__ }
    end
    
    return self
    
  end

  ############################
  #  __autobind_container__  #
  ############################

  def __autobind_container__( data_container )

    @__value__ = data_container
    container.__autobind_container__( data_object ) if container = __container__

    return self

  end
  
  ##########################
  #  __autobind_binding__  #
  ##########################

  def __autobind_binding__( data_binding )
    
    @__value__ = data_binding
    container.__autobind_binding__( data_object ) if container = __container__
    
    return self
    
  end
  
  #########################
  #  __autobind_object__  #
  #########################

  def __autobind_object__( data_object )

    @__value__ = data_object
    container.__autobind_object__( data_object ) if container = __container__

    return self
    
  end

  #######################
  #  __autobind_hash__  #
  #######################
  
  def __autobind_hash__( data_hash )

    @__value__ = data_hash
    container.__autobind_hash__( data_hash ) if container = __container__

    return self
    
  end
  
  ########
  #  []  #
  ########
  
  def []( index )
    
    container = nil
    
    if __permits_multiple__?
      container = @__containers__ ? @__containers__[ index ] : __container__      
    else
      case index
        when 0, -1
          container = __container__
      end
    end
    
    return container
    
  end

  #########
  #  []=  #
  #########
  
  def []=( index, container_instance )

    if __permits_multiple__?
      if @__containers__
        @__containers__[ index ] = container_instance
      else
        case index
          when 0, -1
            self.__containers__ = container_instance
          else
            @__containers__ = [ __container__ ]
        end
      end
      @__containers__ ? @__containers__[ index ] = container_instance 
                      : self.__container__ = container_instance
    else
      case index
        when 0, -1
          self.__container__ = container_instance
        else
          raise ::ArgumentError, ':' << __route_print_string__.to_s << ' does not permit multiple containers.'
      end
    end

    return container_instance
    
  end

  ##########
  #  each  #
  ##########
  
  def each( & block )
    
    return to_enum unless block_given?
    
    if @__containers__
      @__containers__.each( & block )
    elsif container = __container__
      yield( container )
    end
    
    return self
    
  end
  
end
