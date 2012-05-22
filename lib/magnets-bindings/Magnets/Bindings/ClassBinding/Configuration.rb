
module ::Magnets::Bindings::ClassBinding::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique

  ccm = ::CascadingConfiguration::Methods
    
  #########################
  #  container_class      #
  #  __container_class__  #
  #########################

  attr_instance_configuration  :__container_class__

  ccm.alias_instance_method( self, :container_class, :__container_class__ )

end
