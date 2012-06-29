
module ::Magnets::Bindings::ClassBinding::ClassInstance

  include ::CascadingConfiguration::Setting

  #########################
  #  container_class      #
  #  __container_class__  #
  #########################

  attr_configuration  :__container_class__

  Controller.alias_module_and_instance_methods( :container_class, :__container_class__ )

end
