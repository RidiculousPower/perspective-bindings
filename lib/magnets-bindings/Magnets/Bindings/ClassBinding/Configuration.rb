
module ::Magnets::Bindings::ClassBinding::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique

  ccm = ::CascadingConfiguration::Methods
    
  ###############################
  #  bound_container_class      #
  #  __bound_container_class__  #
  #  bound_container            #
  #  __bound_container__        #
  ###############################

  attr_reader  :__bound_container_class__
  
  alias_method  :bound_container_class, :__bound_container_class__
      
  #########################
  #  container_class      #
  #  __container_class__  #
  #########################

  attr_configuration  :__container_class__

  ccm.alias_module_and_instance_methods( self, :container_class, :__container_class__ )

end
