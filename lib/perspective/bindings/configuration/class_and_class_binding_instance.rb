
module ::Perspective::Bindings::Configuration::ClassAndClassBindingInstance

  include ::CascadingConfiguration::Array::Unique

  #############################
  #  __configuration_procs__  #
  #############################
                              
  attr_configuration_unique_array  :__configuration_procs__

  #########################
  #  configuration_procs  #
  #########################

  Controller.alias_instance_method( :configuration_procs, :__configuration_procs__ )

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
