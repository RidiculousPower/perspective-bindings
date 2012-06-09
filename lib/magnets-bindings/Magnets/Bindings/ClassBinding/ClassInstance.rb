
module ::Magnets::Bindings::ClassBinding::ClassInstance

  include ::CascadingConfiguration::Setting

  ccm = ::CascadingConfiguration::Methods

  #########################
  #  container_class      #
  #  __container_class__  #
  #########################

  attr_configuration  :__container_class__

  ccm.alias_module_and_instance_methods( self, :container_class, :__container_class__ )

end
