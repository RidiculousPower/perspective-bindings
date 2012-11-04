
class ::Perspective::Bindings::Container::BindingMethods::InstanceBindingMethods <
      ::Perspective::Bindings::Container::BindingMethods

  
  ####################
  #  define_binding  #
  ####################
  
  def define_binding( binding_name )
  
    super
    
    define_binding_value_setter( binding_name )
  
  end
  
  #################################
  #  define_binding_value_setter  #
  #################################
  
  def define_binding_value_setter( binding_name )
    
    #=================#
    #  binding_name=  #
    #=================#
    
    define_method( binding_name.write_accessor_name ) do |value|

      return __binding__( binding_name ).__value__ = value
      
    end
    
  end

end
