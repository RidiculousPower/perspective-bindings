
module ::Perspective::Bindings::BindingBase::InstanceBinding
  
  include ::Perspective::Bindings::BindingBase
  
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash  

  extend ::Perspective::Bindings::IncludeExtend

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

  end
  
  #####################
  #  __root_string__  #
  #####################

  def __root_string__
    
    return @__root__.__root_string__
    
  end

  ######################
  #  __nested_route__  #
  ######################

  def __nested_route__( nested_in_binding )
    
    return @__parent_binding__.__nested_route__( nested_in_binding )
    
  end

  ##############################
  #  __binding_value_valid__?  #
  ##############################

  def __binding_value_valid__?( binding_value )

    binding_value_valid = false
    
    if binding_value.is_a?( ::Array ) and __permits_multiple__?
      # ensure each member value is valid
      binding_value.each { |this_member| break unless binding_value_valid = __binding_value_valid__?( this_member ) }
    else
      # if we got here (the top) then the only valid value is nil
      binding_value_valid = binding_value.nil?
    end
    
    return binding_value_valid
    
  end

	#################
	#  __equals__?  #
	#################

  alias_method :__equals__?, :==

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

    return object
    
  end

  alias_method  :value=, :__value__=

	########
	#  ==  #
	########
    
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

end
