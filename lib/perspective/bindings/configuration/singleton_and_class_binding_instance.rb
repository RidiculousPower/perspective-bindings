# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Configuration::SingletonAndClassBindingInstance

  include ::CascadingConfiguration::Array::Unique
  
  ###########################
  #  «configuration_procs»  #
  ###########################
                              
  attr_configuration_unique_array  :«configuration_procs»

  #########################
  #  configuration_procs  #
  #########################

  Controller.alias_instance_method( :configuration_procs, :«configuration_procs» )

  #################
  #  «configure»  #
  #################
  
  def «configure»( & configuration_block )

    «configuration_procs».push( configuration_block )
    
    return self
    
  end

  ###############
  #  configure  #
  ###############

  alias_method :configure, :«configure»
  
  ###################
  #  attr_autobind  #
  ###################
  
  def attr_autobind( binding_name_or_instance )

    self.«autobind_value_to_binding» = binding_name_or_instance

    return self
    
  end  
  
end
