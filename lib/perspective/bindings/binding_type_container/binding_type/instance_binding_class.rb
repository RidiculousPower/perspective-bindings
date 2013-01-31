
class ::Perspective::Bindings::BindingTypeContainer::BindingType::InstanceBindingClass < 
      ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingClass
  
  NonForwardingMethodsArray = [ :method_missing, :respond_to_missing?, :object_id, :hash, :==,
                                :equal?, :class, 
                                :view, :view=, :container, :container=, :to_html_node ]
  
  NonForwardingMethods = ::Hash[ ::Perspective::Bindings::BindingTypeContainer::BindingType::
                                   InstanceBindingClass::NonForwardingMethodsArray.zip ]
  
  # These have to be manually renamed or we have to call :send to use them.
  # For instance :__<=>__ is a legitimate method name, but not legitimate Ruby syntax,
  # so it can only be called via object.send( :"__<=>__", *args ).

  alias_method( :__compare__, :"<=>" )
  undef_method( :"<=>" )

  alias_method( :__not__, :"!" )
  undef_method( :"!" )

  alias_method( :__not_equal__, :"!=" )
  undef_method( :"!=" )

  alias_method( :__regexp__, :"=~" )
  undef_method( :"=~" )

  alias_method( :__case_equals__, :=== )
  undef_method( :=== )

  alias_method( :__regexp_equals__, :"!~" )
  undef_method( :"!~" )

  alias_method( :__object_id__, :object_id )
    
  # Rename all methods to __method__.
  # Special characters (?!) get moved to the end: __method__?!.
  instance_methods.each do |this_method|
    
    case this_method
      when *::Perspective::Bindings::BindingTypeContainer::BindingType::InstanceBindingClass::NonForwardingMethodsArray
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

    if self.class::NonForwardingMethods.has_key?( method )
      responds = false
    end
    
    return responds
    
  end

end
