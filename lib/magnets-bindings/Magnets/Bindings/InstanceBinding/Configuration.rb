
module ::Magnets::Bindings::InstanceBinding::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash

  ccm = ::CascadingConfiguration::Methods
  
  ########################
  #  parent_binding      #
  #  __parent_binding__  #
  ########################

  attr_reader  :__parent_binding__

  alias_method  :parent_binding, :__parent_binding__

  ##############
  #  container      #
  #  __container__  #
  ##############

  attr_instance_configuration  :__container__

  ccm.alias_instance_method( self, :container, :__container__ )
  
end
