
module ::Magnets::Bindings::Configuration::BindingInstance

  include ::CascadingConfiguration::Setting

  ccm = ::CascadingConfiguration::Methods

  #########################
  #  bound_container      #
  #  __bound_container__  #
  #########################

  attr_reader  :__bound_container__

  alias_method  :bound_container, :__bound_container__

  ##############
  #  name      #
  #  __name__  #
  ##############
  
  attr_instance_configuration  :__name__

  ccm.alias_instance_method( self, :name, :__name__ )
  
  ###################
  #  required?      #
  #  required=      #
  #  __required__=  #
  ###################

  attr_instance_configuration  :required? => :__required__=

  ccm.alias_instance_method( self, :required=, :__required__= )

  ###############
  #  optional?  #
  ###############
  
  def optional?
  
    return ! required?
  
  end
  
end
