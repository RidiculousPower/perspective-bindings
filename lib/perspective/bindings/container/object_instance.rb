# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Container::ObjectInstance

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::Configuration::ObjectAndBindingInstance
  include ::Perspective::Bindings::Container::Configuration
  include ::Perspective::Bindings::Container::ObjectAndBindingInstance

  include ::Perspective::Bindings::Container::SingletonAndObjectInstance

  include ::CascadingConfiguration::Hash
  
  ###########################
  #  «initialize_instance»  #
  ###########################
  
  def «initialize_instance»

    «configure_containers»
    
    return self
    
  end

  ##########################
  #  initialize_for_index  #
  ##########################
  
  def initialize_for_index( index )
    
    # nothing to do - implemented to permit overriding
    
  end

  ###########################
  #  «initialize_bindings»  #
  ###########################
  
  def «initialize_bindings»

    «bindings».each do |this_name, this_binding|
      this_binding.«initialize_bindings» if this_binding.respond_to?( :«initialize_bindings» )
	  end
  	  
  end
  
  ############################
  #  «configure_containers»  #
  ############################
  
  def «configure_containers»

    «bindings».each { |this_name, this_binding| «configure_container_for_binding»( this_binding ) }

  end

  #######################################
  #  «configure_container_for_binding»  #
  #######################################
  
  def «configure_container_for_binding»( binding_instance )

    binding_instance.«configure_container» if binding_instance.respond_to?( :«configure_container» )

  end

  ################
  #  «bindings»  #
  ################

	attr_instance_hash  :«bindings» do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( binding_name, binding_instance, parent_hash )

      child_instance = nil

      case parent_instance = parent_hash.configuration_instance
        
        when ::Perspective::Bindings::Container::SingletonInstance

          # We are inheriting as a root container instance.
          # We need instance bindings corresponding to the declared class bindings
          child_instance = binding_instance.class::InstanceBinding.new( binding_instance, configuration_instance )
        
        when ::Perspective::Bindings::InstanceBinding

          if parent_instance.permits_multiple? and 
             parent_instance.«container»( nil, false ) != ( instance = configuration_instance )
            # We were created by an instance binding as a multiple container (> index 0).
            #
            # We need new instance bindings or we end up with the same binding instances as the
            # first container for this instance binding.
            child_instance = binding_instance.class::InstanceBinding.new( binding_instance.«parent_binding», 
                                                                          instance )
          else
            # We were created by an instance binding.
            #
            # We want the same instance bindings we attached to the instance binding that
            # this container is attached to.
            child_instance = binding_instance
          end

      end

      return child_instance

    end
    
  end

  ##############
  #  is_root?  #
  ##############
  
  def is_root?
    
    return @«bound_container».nil?
    
  end
  
  ############
  #  «name»  #
  ############
  
  def «name»
    
    name = nil
    
    if @«parent_binding»
      name = @«parent_binding».«name»
    else
      name = «root_string»
    end
    
    return name
    
  end
  
  ############
  #  «root»  #
  ############
  
  def «root»
    
    root_instance = nil
    
    if @«bound_container»
      root_instance = @«bound_container».«root»
    else
      root_instance = self
    end
    
    return root_instance
    
  end

  ##########
  #  root  #
  ##########

  alias_method  :root, :«root»

  ###################
  #  «root_string»  #
  ###################

  def «root_string»
    
    # [root:<instance>]
    
    root_string = nil
    
    if «root» == self
      @«root_string» ||= '<root:' << to_s << '>'
      root_string = @«root_string»
    else
      root_string = «root».«root_string»
    end

    return root_string
    
  end

  #############
  #  «route»  #
  #############

  def «route»
    
    route = nil
    
    if @«parent_binding»
      route = @«parent_binding».«route»
    end
    
    return route
    
  end

  ###########
  #  route  #
  ###########
  
  alias_method  :route, :«route»

  #####################
  #  route_with_name  #
  #####################

  def «route_with_name»
    
    route_with_name = nil
    
    if @«parent_binding»
      route_with_name = @«parent_binding».«route_with_name»
    end
    
    return route_with_name
    
  end

  #######################
  #  «route_with_name»  #
  #######################
  
  alias_method  :route_with_name, :«route_with_name»

  ###########################
  #  view_rendering_empty?  #
  ###########################

  def view_rendering_empty?
    
    return @«view_rendering_empty» ||= false
    
  end

  ################
  #  «autobind»  #
  ################
  
  def «autobind»( data_object )
    
    @«view_rendering_empty» = false

    found_a_binding = false
    
    case data_object
      when ::Perspective::Bindings::Container
        found_a_binding = «autobind_container»( data_object )
      when ::Perspective::Bindings::InstanceBinding
        found_a_binding = «autobind_binding»( data_object )
      when ::Hash
        found_a_binding = «autobind_hash»( data_object )
      when ::Array
        found_a_binding = «autobind_array»( data_object )
      else
        found_a_binding = «autobind_object»( data_object )
    end

    unless found_a_binding
      if autobinds_value?
        «autobinds_value»( data_object )
      else
        raise ::Perspective::Bindings::Exception::AutobindFailed, 
                ':autobind was called on ' << self.to_s << ' but data object did not respond ' <<
                'to the name of any declared bindings in ' << self.to_s << 
                ', no method map was provided, and ' << self.to_s << 
                ' responds false to :autobind_value?.'
      end
    end
    
    return self
    
  end

  ##############
  #  autobind  #
  ##############
  
  alias_method  :autobind, :«autobind»

  ######################
  #  «autobind_array»  #
  ######################

  def «autobind_array»( data_binding )
    
    raise ::ArgumentError, 'Container does not know how to resolve Array value for autobind.'
    
  end

  ##########################
  #  «autobind_container»  #
  ##########################

  def «autobind_container»( data_container )
    
    found_a_binding = false
    
    «bindings».each do |this_binding_name, this_binding|
      if data_container.has_binding?( this_binding_name )
        this_data_binding = data_container.«binding»( this_binding_name )
        this_binding.«autobind_binding»( this_data_binding )
        found_a_binding = true
      end
    end
    
    return found_a_binding
    
  end

  ########################
  #  «autobind_binding»  #
  ########################
  
  def «autobind_binding»( data_binding )
    
    if found_a_binding = has_binding?( data_binding_name = data_binding.«name» )
      «binding»( data_binding_name ).«autobind_binding»( data_binding.«value» )
    end
    
    found_a_binding = true if «autobind_container»( data_binding )

    return found_a_binding
    
  end
  
  #######################
  #  «autobind_object»  #
  #######################

  def «autobind_object»( data_object )
    
    found_a_binding = false

    «bindings».each do |this_binding_name, this_binding|
      if data_object.respond_to?( this_binding_name )
        this_binding.«autobind»( data_object.__send__( this_binding_name ) )
        found_a_binding = true
      end    
    end
    
    found_a_binding = «autobind_value»( data_object, false ) unless found_a_binding
    
    return found_a_binding
    
  end

  #####################
  #  «autobind_hash»  #
  #####################
  
  def «autobind_hash»( data_hash )

    found_a_binding = false
    
    «bindings».each do |this_binding_name, this_binding|
      if data_hash.has_key?( this_binding_name )
        this_binding.«autobind»( data_hash[ this_binding_name ] )
        found_a_binding = true
      end
    end
    
    return found_a_binding
    
  end
  
  ######################
  #  «autobind_value»  #
  ######################
  
  def «autobind_value»( value, ensure_autobind = true )
    
    autobound = false
    
    if autobind_binding = «autobind_value_to_binding»
      if sub_autobinding = autobind_binding.«autobind_value_to_binding»
        autobind_binding.«autobind_value»( value )
      else
        autobind_binding.«value» = value
      end
    else
      if ensure_autobind
        raise ::ArgumentError, 'Cannot autobind value - no binding set for :«autobind_value_to_binding» ' << 
                               '(generally set through :attr_autobind).'
      else
        autobound = true
      end
    end
    
    return ensure_autobind ? self : autobound
    
  end
  
  ####################
  #  «nested_route»  #
  ####################

  def «nested_route»( nested_binding )

    nested_route = nil
    
    if @«parent_binding»
      nested_route = @«parent_binding».«nested_route»( nested_binding )
    else
      nested_route = nested_binding.«route»
    end

    return nested_route
    
  end
  
  ##################
  #  nested_route  #
  ##################
  
  alias_method  :nested_route, :«nested_route»

  ########
  #  []  #
  ########
  
  def []( binding_name )

    return «binding»( binding_name )
    
  end
  
end
