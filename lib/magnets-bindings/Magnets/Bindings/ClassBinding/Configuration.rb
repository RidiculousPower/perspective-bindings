
module ::Magnets::Bindings::ClassBinding::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique

  ccm = ::CascadingConfiguration::Methods

  ##############################################
  #  __initialize_for_bound_container_class__  #
  ##############################################
  
  def __initialize_for_bound_container_class__( bound_container_class )
    
    @__bound_container_class__ = bound_container_class
    
  end
    
  ###############################
  #  bound_container_class      #
  #  __bound_container_class__  #
  ###############################

  attr_accessor  :__bound_container_class__
  
  alias_method  :bound_container_class, :__bound_container_class__
  alias_method  :bound_container_class=, :__bound_container_class__=
    
  #########################
  #  container_class      #
  #  __container_class__  #
  #########################

  attr_configuration  :__container_class__

  ccm.alias_module_and_instance_methods( self, :container_class, :__container_class__ )

end
