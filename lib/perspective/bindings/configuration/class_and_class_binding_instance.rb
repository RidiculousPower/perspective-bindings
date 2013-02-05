
module ::Perspective::Bindings::Configuration::ClassAndClassBindingInstance

  ###################
  #  __configure__  #
  ###################
  
  def __configure__( & configuration_block )
    
    __configuration_procs__.push( configuration_block )
    
    return self
    
  end

  ###############
  #  configure  #
  ###############

  alias_method :configure, :__configure__
  
end
