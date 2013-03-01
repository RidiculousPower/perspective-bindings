# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Configuration::SingletonAndClassBindingInstance

  include ::CascadingConfiguration::Array::Unique
  
  #############################
  #  «configuration_procs  #
  #############################
                              
  attr_configuration_unique_array  :«configuration_procs

  #########################
  #  configuration_procs  #
  #########################

  Controller.alias_instance_method( :configuration_procs, :«configuration_procs )

  ###################
  #  «configure  #
  ###################
  
  def «configure( & configuration_block )

    «configuration_procs.push( configuration_block )
    
    return self
    
  end

  ###############
  #  configure  #
  ###############

  alias_method :configure, :«configure
  
end
