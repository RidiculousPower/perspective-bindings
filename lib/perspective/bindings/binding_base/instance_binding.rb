
module ::Perspective::Bindings::BindingBase::InstanceBinding
  
  include ::Perspective::Bindings::BindingBase
  
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash  

  extend ::Module::Cluster
  
  cluster( :instance_binding_forwarding ).before_include.cascade_to( :class ) do |hooked_instance|
    
    hooked_instance.class_eval do
      
      # These have to be manually renamed or we have to call :send to use them.
      # For instance :__<=>__ is a legitimate method name, but not legitimate Ruby syntax,
      # so it can only be called via object.send( :"__<=>__", *args ).

      if method_defined?( :"<=>" )
        alias_method( :__compare__, :"<=>" )
        undef_method( :"<=>" )
      end

      if method_defined?( :! )
        alias_method( :__not__, :"!" )
        undef_method( :"!" )
      end

      if method_defined?( :!= )
        alias_method( :__not_equal__, :"!=" )
        undef_method( :"!=" )
      end

      if method_defined?( :=~ )
        alias_method( :__regexp__, :"=~" )
        undef_method( :"=~" )
      end

      if method_defined?( :=== )
        alias_method( :__case_equals__, :=== )
        undef_method( :=== )
      end

      if method_defined?( :"!~" )
        alias_method( :__regexp_equals__, :"!~" )
        undef_method( :"!~" )
      end

      alias_method( :__object_id__, :object_id )
      
      
      # Rename all methods to __method__.
      # Special characters (?!) get moved to the end: __method__?!.
      instance_methods.each do |this_method|
        
        case this_method
          when :method_missing, :object_id, :hash, :==,
               :equal?, :class, 
               :view, :view=, :container, :container=, :to_html_node
            next
        end
        
        this_method = this_method.to_s
        
        ends_with_special_char = false
        
        case this_method[ 0 ]
          when '_'
            next
        end
        
        case this_method[ -1 ]
          when '?', '!', '='
            ends_with_special_char = this_method[ -1 ]
            this_method = this_method.slice( 0, this_method.length - 1 )
        end
        
        if this_method.empty?
          alias_name = '__'
        else
          alias_name = '__' + this_method.to_s + '__'
        end
        
        if ends_with_special_char
          alias_name += ends_with_special_char
          this_method += ends_with_special_char
        end
        
        # Create new method name
        alias_method( alias_name, this_method )
        
        # Remove old method name
        undef_method( this_method )
        
      end
      
    end
    
  end

  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding, bound_container_instance )
        
    @__parent_binding__ = parent_class_binding
    @__bound_container__ = bound_container_instance
    
    @__root__ = @__bound_container__.__root__
    
    # register parent class binding as ancestor for configurations
    ::CascadingConfiguration.register_parent( self, @__parent_binding__ )

    self.__route_print_string__ = ::Perspective::Bindings.context_print_string( @__root__, __route_string__ )
    
    if container_class = @__parent_binding__.__container_class__    
      __extend__( container_class::Controller::InstanceBindingMethods )
    end

  end
  
  #########################################
  #  __initialize_container_from_class__  #
  #########################################
  
  def __initialize_container_from_class__( container_class = @__parent_binding__.__container_class__ )

    container_instance = container_class::Nested.new( self )
    
    # :__store_initialized_container_instance__ is used instead of :__container__= 
    # so that we can store without any overloaded effects.
    __store_initialized_container_instance__( container_instance )
    
    return container_instance
    
  end
  
  ##############################
  #  __initialize_container__  #
  ##############################
  
  def __initialize_container__
    
    # ensure container is created
    __container__
    
    # cascade
    __bindings__.each do |this_binding_name, this_binding_instance|
      this_binding_instance.__initialize_container__
    end
    
  end
  
  ####################
  #  method_missing  #
  ####################
  
  def method_missing( method, *args, & block )

    begin
      # Forward method call to value
      return __value__.__send__( method, *args, & block )
    rescue ::Exception => exception
      exception.reraise( 2 )
    end
    
  end
  
  #############################
  #  __configure_container__  #
  #############################
  
  def __configure_container__( bound_container = __bound_container__ )
      
    # run configuration proc for each binding instance
		__configuration_procs__.each do |this_configuration_proc|
      bound_container.__instance_exec__( self, & this_configuration_proc )
	  end
	  
    __bindings__.each do |this_binding_name, this_binding_instance|
      this_binding_instance.__configure_container__
    end
	  
	  return self
    
  end
  
  ###################
  #  container      #
  #  __container__  #
  ###################

  attr_instance_configuration  :__container__

  Controller.alias_instance_method( :container, :__container__ )

  def __container__
    
    container_instance = nil

    unless container_instance = super

      if container_class = @__parent_binding__.__container_class__

        container_instance = __initialize_container_from_class__
      
      end
    
    end
    
    return container_instance
    
  end

  alias_method( :container, :__container__ )

  ##############################################
  #  container=                                #
  #  __container__=                            #
  #  __store_initialized_container_instance__  #
  ##############################################
  
  alias_method :__store_initialized_container_instance__, :__container__=
  
  def __container__=( container_instance )
    
    super

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
    ::CascadingConfiguration.replace_parent( self, @__parent_binding__, container_instance )
        
  end

  alias_method( :container=, :__container__= )

  ###############
  #  value      #
  #  __value__  #
  ###############
  
  attr_reader  :__value__

  alias_method  :value, :__value__

  ################
  #  value=      #
  #  __value__=  #
  ################

  def __value__=( object )
    
    case object
      
      when ::Perspective::Bindings::BindingBase::InstanceBinding

        if __is_a__?( ::Perspective::Bindings::ReferenceBinding )

          @__value__ = object
          
        else

          @__value__ = object.__value__

        end
      
      else

        unless __binding_value_valid__?( object )
          raise ::Perspective::Bindings::Exception::BindingInstanceInvalidType, 
                  'Invalid value ' <<  object.inspect + ' assigned to binding :' << __name__.to_s + '.'
        end

        @__value__ = object
        
    end    
    
    __autobind__( @__value__ )

    return object
    
  end

	########
	#  ==  #
	########
  
  alias_method :__equals__?, :==
  
  def ==( object )
    
    is_equal = nil

    value = __value__
    
    if __is_a__?( ::Perspective::Bindings::ReferenceBinding ) and
       value.__is_a__?( ::Perspective::Bindings::BindingBase::InstanceBinding )

      is_equal = value.__equals__?( object )

    else

      is_equal = ( value == object )

    end
    
    return is_equal
    
  end

	########################
	#  __autobind_value__  #
	########################
	
	def __autobind_value__( current_value = __value__ )
	  
    return current_value
    
  end
  
  ##################
  #  __autobind__  #
  ##################
  
  def __autobind__( data_object, method_map_hash = nil )

    # We can't autobind to a container that isn't there yet.
    if container = __container__

      case data_object

        when ::Array
                    
          if __permits_multiple__?

            if data_object.count - 1 > 0

              binding_value_array = data_object.collect do |this_data_object|
                __autobind_value__( this_data_object )
              end
            
              case container
                when ::Perspective::Bindings::Container::MultiContainerProxy
                  container.__autobind__( *binding_value_array, method_map_hash )
                else
                  __create_multi_container_proxy__( data_object )
              end

            else

              container.__autobind__( __autobind_value__( data_object[ 0 ] ), method_map_hash )

            end
          
          end
          
        else
          
          container.__autobind__( __autobind_value__( data_object ), method_map_hash )
          
      end
    
    end
    
  end
  
  alias_method  :autobind, :__autobind__

  ######################################
  #  __create_multi_container_proxy__  #
  ######################################
  
  def __create_multi_container_proxy__( data_object )

    multi_proxy = ::Perspective::Bindings::Container::MultiContainerProxy.new( self, *data_object )

    self.__store_initialized_container_instance__( multi_proxy )
    
    return multi_proxy
    
  end

  ##############################
  #  __binding_value_valid__?  #
  ##############################

  def __binding_value_valid__?( binding_value )

    binding_value_valid = false
    
    if binding_value.is_a?( ::Array ) and __permits_multiple__?
    
      # ensure each member value is valid
      binding_value.each do |this_member|
        
        break unless binding_value_valid = __binding_value_valid__?( this_member )
        
      end
    
    else
      
      # if we got here (the top) then the only valid value is nil
      binding_value_valid = binding_value.nil?
      
    end
    
    return binding_value_valid
    
  end

end
