# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::InstanceBinding
  
  include ::Perspective::Bindings::BindingBase
  
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash  

  extend ::Perspective::Bindings::IncludeExtend

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

  #############
  #  «value»  #
  #############
  
  attr_reader  :«value»

  ###########
  #  value  #
  ###########

  alias_method  :value, :«value»

  ##############
  #  «value»=  #
  ##############

  def «value»=( object )
    
    case object
      
      when ::Perspective::Bindings::InstanceBinding

        if ::Perspective::Bindings::ReferenceBinding === self
          @«value» = object
        else
          @«value» = object.«value»
        end
      
      else

        unless binding_value_valid?( object )
          raise ::Perspective::Bindings::Exception::BindingInstanceInvalidType, 
                  'Invalid value ' <<  object.inspect + ' assigned to binding :' << «name».to_s + '.'
        end

        @«value» = object
        
    end    

    return object
    
  end

  ############
  #  value=  #
  ############

  alias_method  :value=, :«value»=

end
