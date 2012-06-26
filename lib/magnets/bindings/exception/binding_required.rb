
class ::Magnets::Bindings::Exception::BindingRequired < ::ArgumentError
  
  ################
  #  initialize  #
  ################
  
  def initialize( binding_instance = nil )
    
    if binding_instance

      exception_string =  'Binding value required for ' << 
                          binding_instance.__route_print_string__.to_s
      exception_string << ' but received nil.'
    
      super( exception_string )

    else

      super

    end
    
  end
  
end
