
module ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  
  include ::CascadingConfiguration::Setting
  include ::Perspective::Bindings::Container::Configuration
  include ::Perspective::Bindings::Container::ObjectAndBindingInstance
  
  include ::Enumerable
  
  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding, bound_container_instance )
        
    super
    
    «initialize_container_from_class

  end
  
  #########################################
  #  «initialize_container_from_class  #
  #########################################
  
  def «initialize_container_from_class( container_class = @«parent_binding.«container_class )
    
    container_instance = nil
    
    if container_class
      extend( container_class::Controller::InstanceBindingMethods )
      container_instance = container_class.new_nested_instance( self )
      # if we could have multiple then we initialize for the first index
      container_instance.initialize_for_index( 0 ) if permits_multiple?
      # :«store_initialized_container_instance is used instead of :«container= 
      # so that we can store without any overloaded effects.
      «store_initialized_container_instance( container_instance )
      # if we have a value, autobind it to new container
      «autobind( @«value )
    end
    
    return container_instance
    
  end
  
  #############################
  #  «initialize_bindings  #
  #############################
  
  def «initialize_bindings
    
    «container
    «bindings.each { |this_binding_name, this_binding| this_binding.«initialize_bindings }
    
  end
  
  #############################
  #  «configure_container  #
  #############################
  
  def «configure_container( bound_container = «bound_container )
      
    # run configuration proc for each binding instance
		@«parent_binding.«configuration_procs.each do |this_configuration_proc|
      bound_container.instance_exec( self, & this_configuration_proc )
	  end
	  
    «bindings.each { |this_binding_name, this_binding| this_binding.«configure_container }
	  
	  return self
    
  end

  ####################
  #  has_container?  #
  ####################
  
  def has_container?
    
    return «container( false ) ? true : false
    
  end
  
  ###################
  #  «container  #
  ###################

  attr_instance_configuration  :«container

  def «container( initialize_container = true )
    
    container_instance = nil

    unless ! initialize_container or container_instance = super()
      if container_class = @«parent_binding.«container_class
        container_instance = «initialize_container_from_class
      end
    end
    
    return container_instance
    
  end

  ##############################################
  #  «store_initialized_container_instance  #
  ##############################################
  
  alias_method :«store_initialized_container_instance, :«container=
  
  ####################
  #  «container=  #
  ####################

  def «container=( container_instance )
    
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
      ::CascadingConfiguration.replace_parent( self, @«parent_binding, container_instance )
      
      # if we have a value, autobind it to new container
      «autobind( @«value )
      
    end
    
  end

  ###############
  #  container  #
  ###############

  alias_method( :container, :«container )

  ################
  #  container=  #
  ################

  alias_method( :container=, :«container= )

  #####################################
  #  «create_additional_container  #
  #####################################

  def «create_additional_container( container_class = @«parent_binding.«container_class )
    
    @«containers ||= [ «container ]
    
    new_container_instance = container_class.new_nested_instance( self )
    index = @«containers.size
    @«containers.push( new_container_instance )
    new_container_instance.initialize_for_index( index )

    return new_container_instance
    
  end
  
  ################################
  #  «ensure_container_count  #
  ################################
  
  def «ensure_container_count( container_count, container_class = @«parent_binding.«container_class )

    unless container_class
      raise ::ArgumentError, 'Could not create any containers because no container class was defined or provided.'
    end

    if container_count > 1
      
      unless permits_multiple?
        raise ::ArgumentError, "Multiple not permitted for " << container.to_s << '.' 
      end
    
      case container_count
        when 1
          «container
        else
          while ! @«containers or @«containers.size < container_count
            «create_additional_container( container_class )
          end
      end
      
    end
    
    return self
    
  end

  ##################
  #  «autobind  #
  ##################

  def «autobind( data_object )
        
    case data_object
      when nil
        @«value = nil
      when ::Array
        «autobind_array( data_object )
      when ::Hash
        «autobind_hash( data_object )
      when ::Perspective::Bindings::BindingBase::InstanceBinding
        «autobind_binding( data_object )
      when ::Perspective::Bindings::Container::ObjectInstance
        «autobind_container( data_object )
      else
        «autobind_object( data_object )
    end
    
    return data_object
    
  end

  ##############
  #  autobind  #
  ##############
  
  alias_method  :autobind, :«autobind
  
  ########################
  #  «autobind_array  #
  ########################

  def «autobind_array( data_array )
    
    self.«value = data_array
    
    case autobind_item_count = data_array.size
      when 0
        # empty array, do nothing
      when 1
        # bind as normal object - no reason to treat as list
        «autobind_object( data_array[ 0 ] )
      else
        # array maps each index to each of multiple containers
        «ensure_container_count( autobind_item_count )
        @«containers.each_with_index do |this_container, this_index|
          this_container.«autobind_object( data_array[ this_index ] )
        end
    end
    
    return self
    
  end

  ############################
  #  «autobind_container  #
  ############################

  def «autobind_container( data_container )

    if container = «container
      container.«autobind_container( data_container )
    end
    
    return self

  end
  
  ##########################
  #  «autobind_binding  #
  ##########################

  def «autobind_binding( data_binding )
    
    # if we identify as binding name, copy value
    if data_binding.«name == «name
      self.«value = data_binding.«value
    end
    
    # if we have sub-bindings that match, copy them
    if container = «container
      «autobind_container( data_binding )
    elsif data_binding.has_binding?( :content )
      «autobind_binding( data_binding.content )
    end
    
    return self
    
  end
  
  #########################
  #  «autobind_object  #
  #########################

  def «autobind_object( data_object )

    if container = «container
      container.«autobind_object( data_object )
    else
      self.«value = data_object
    end

    return self
    
  end

  #######################
  #  «autobind_hash  #
  #######################
  
  def «autobind_hash( data_hash )

    if container = «container
      container.«autobind_hash( data_hash )
    end

    return self
    
  end
  
  #########################
  #  «container_count  #
  #########################
  
  def «container_count
    
    container_count = nil
    
    if permits_multiple? and @«containers
      container_count = @«containers.size
    else
      container_count = «container( false ) ? 1 
                                               : @«parent_binding.«container_class ? 1 : 0
    end
    
    return container_count
    
  end
  
  ########
  #  []  #
  ########
  
  def []( index_or_binding_name )
    
    container = nil
    
    case index_or_binding_name

      when ::Symbol, ::String

        container = «binding( binding_name = index_or_binding_name )

      else
        
        index = index_or_binding_name
        
        «ensure_container_count( index + 1 )

        case index
          when 0
            container = «container
          else
            @«containers ||= [ «container ]
            container = @«containers[ index ]
        end

    end
        
    return container
    
  end

  #########
  #  []=  #
  #########
  
  def []=( index, container_instance )

    «ensure_container_count( index + 1 )

    case index
      when 0
        self.«container = container_instance
      when -1
        if permits_multiple?
          if @«containers
            @«containers[ index ] = container_instance
          else
            self.«container = container_instance
          end
        else
          self.«container = container_instance
        end
      else
        if index < 0
          if ! @«containers
            raise IndexError, 'index ' << index.to_s << ' too small for array; minimum: -1'
          elsif -@«containers.size < index
            raise IndexError, 'index ' << index.to_s << ' too small for array; minimum: ' << 
                              (-@«containers.size).to_s
          end
        end
        @«containers[ index ] = container_instance
    end

    return container_instance
    
  end

  ##########
  #  each  #
  ##########
  
  def each( & block )
    
    return to_enum unless block_given?
    
    if @«containers
      @«containers.each( & block )
    elsif container = «container
      yield( container )
    end
    
    return self
    
  end
  
end
