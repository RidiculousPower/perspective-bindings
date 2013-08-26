# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::InstanceBinding
  
  include ::Perspective::Bindings::Binding
  
  extend ::CascadingConfiguration::Setting
  extend ::CascadingConfiguration::Hash  

  extend ::Perspective::Bindings::IncludeExtendForwarding

  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding, bound_container_instance )
        
    @«parent_binding» = parent_class_binding
    @«bound_container» = bound_container_instance
    
    @«root» = @«bound_container».«root»

    # register parent class binding as ancestor for configurations
    ::CascadingConfiguration.register_parent( self, @«parent_binding» )

    self.«route_print_string» = ::Perspective::Bindings.context_print_string( @«root», «route_string» )

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
        
        when ::Perspective::Bindings::ClassBinding

          child_instance = binding_instance.class::InstanceBinding.new( binding_instance, configuration_instance )
        
        when ::Perspective::Bindings::Container::ObjectInstance
        
          # inheriting from an object instance assigned to this instance binding as its container
          child_instance = binding_instance
          
      end

      return child_instance

    end
    
  end
	
  ###################
  #  «root_string»  #
  ###################

  def «root_string»
    
    return @«root».«root_string»
    
  end

  ####################
  #  «nested_route»  #
  ####################

  def «nested_route»( nested_in_binding )
    
    return @«parent_binding».«nested_route»( nested_in_binding )
    
  end

  ##########################
  #  binding_value_valid?  #
  ##########################

  def binding_value_valid?( binding_value )

    binding_value_valid = false
    
    if binding_value.is_a?( ::Array ) and permits_multiple?
      # ensure each member value is valid
      binding_value.each { |this_member| break unless binding_value_valid = binding_value_valid?( this_member ) }
    else
      # if we got here (the top) then the only valid value is nil
      binding_value_valid = binding_value.nil?
    end
    
    return binding_value_valid
    
  end

  ##############
  #  «value»=  #
  ##############

  def «value»=( object )
    
    case object
      
      when ::Perspective::Bindings::InstanceBinding

        super( ::Perspective::Bindings::ReferenceBinding === self ? object : object.«value» )

      else

        unless binding_value_valid?( object )
          raise ::Perspective::Bindings::Exception::BindingInstanceInvalidType, 
                  'Invalid value ' <<  object.inspect + ' assigned to binding :' << «name».to_s + '.'
        end

        super( object )
        
    end    

    return object
    
  end

  ############
  #  value=  #
  ############

  alias_method  :value=, :«value»=

end
