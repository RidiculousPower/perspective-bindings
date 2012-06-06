
class ::Magnets::Bindings::Exception::BindingRequired < ::ArgumentError
  
  ################
  #  initialize  #
  ################
  
  def initialize( binding_instance = nil )
    
    if binding_instance
      exception_string = 'Binding value required for :' << binding_instance.__name__.to_s <<
                         ' but received nil at route :' << binding_instance.__route_string__ << '.'
    
      super( exception_string )
    else
      super
    end
    
  end
  
end
