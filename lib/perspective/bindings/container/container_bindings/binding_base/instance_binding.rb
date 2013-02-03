
module ::Perspective::View::Bindings::BindingBase::InstanceBinding
  
  include ::Perspective::View::Configuration
  include ::Perspective::View::ObjectAndBindingInstance

  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding, bound_container_instance )
        
    super
    
    if container_class = @__parent_binding__.__container_class__    
      __extend__( container_class::Controller::InstanceBindingMethods )
    end

  end
  
  #########################################
  #  __initialize_container_from_class__  #
  #########################################
  
  def __initialize_container_from_class__( container_class = @__parent_binding__.__container_class__ )

    container_instance = container_class.new_nested_instance( self )
    
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
  
  ################
  #  value=      #
  #  __value__=  #
  ################

  def __value__=( object )
    
    super
    
    __autobind__( @__value__ )

    return object
    
  end

  alias_method  :value=, :__value__=
  
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

  ###############
  #  view       #
  #  view=      #
  #  __view__   #
  #  __view__=  #
  ###############

  cluster( :aliases ).before_include.cascade_to( :module ) do |hooked_instance|
    
    hooked_instance.class_eval do

      alias_method :__view__, :__container__
      alias_method :__view__=, :__container__=

      alias_method :view, :__view__
      alias_method :view=, :__view__=
      
    end
  
  end
  
	########################
	#  __render_value__    #
	#  __autobind_value__  #
	########################
	
	def __autobind_value__( current_value = __value__ )
	  
    return current_value
    
  end
  
  alias_method  :__render_value__, :__autobind_value__

  #############################
  #  __render_value_valid__?  #
  #############################

  def __render_value_valid__?( ensure_valid = false, 
                               view_rendering_empty = @__view_rendering_empty__ )
    
    render_value_valid = true

    if __required__? and ! view_rendering_empty and __value__.nil?
      render_value_valid = false
    elsif view = __view__
      render_value_valid = view.__render_value_valid__?( ensure_valid, view_rendering_empty )
    end

    if ensure_valid and ! render_value_valid
      raise ::Perspective::Bindings::Exception::BindingRequired.new( self )
    end
    
    return render_value_valid
    
  end

end
