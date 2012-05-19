
module ::Magnets::Binding::InstanceBinding::Configuration

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
  #  view      #
  #  __view__  #
  ##############

  attr_instance_configuration  :__view__

  ccm.alias_instance_method( self, :view, :__view__ )
  
end
