
module ::Perspective::Bindings::BindingBase::InstanceBinding
  
  include ::Perspective::Bindings::BindingBase
  
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash  

  extend ::Module::Cluster
  
  NonForwardingMethodsArray = [ :method_missing, :respond_to_missing?, :object_id, :hash, :==,
                                :equal?, :class, 
                                :view, :view=, :container, :container=, :to_html_node ]
  
  NonForwardingMethods = ::Hash[ ::Perspective::Bindings::BindingBase::InstanceBinding::NonForwardingMethodsArray.zip ]
  
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
          when *::Perspective::Bindings::BindingBase::InstanceBinding::NonForwardingMethodsArray
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
        
        alias_name = this_method.empty? ? '__' : ( '__' << this_method.to_s ) << '__'
        
        if ends_with_special_char
          alias_name << ends_with_special_char
          this_method << ends_with_special_char
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

  #########################
  #  respond_to_missing?  #
  #########################
  
  def respond_to_missing?( method, include_private )
    
    responds = true

    if ::Perspective::Bindings::BindingBase::InstanceBinding::NonForwardingMethods.has_key?( method )
      responds = false
    end
    
    return responds
    
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
