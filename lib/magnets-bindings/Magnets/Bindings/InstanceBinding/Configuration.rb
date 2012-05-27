
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

  ########################################
  #  __initialize_for_bound_container__  #
  ########################################
  
  def __initialize_for_bound_container__( bound_container )
    
    @__bound_container__ = bound_container
    
  end

  #########################
  #  bound_container      #
  #  __bound_container__  #
  #########################

  attr_accessor  :__bound_container__

  alias_method  :bound_container, :__bound_container__

  ###################
  #  container      #
  #  __container__  #
  ###################

  attr_instance_configuration  :__container__

  ccm.alias_instance_method( self, :container, :__container__ )

end
