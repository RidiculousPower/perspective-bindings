
module ::Magnets::Bindings::InstanceBinding::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash

  ccm = ::CascadingConfiguration::Methods
  
  ########################################
  #  __initialize_for_bound_container__  #
  ########################################
  
  def __initialize_for_bound_container__( bound_container )
    
    @__bound_container__ = bound_container
        
  end

  ###################
  #  container      #
  #  __container__  #
  ###################

  attr_instance_configuration  :__container__

  ccm.alias_instance_method( self, :container, :__container__ )

  def __container__
    
    container_instance = nil

    unless container_instance = super
      
      if container_class = @__parent_binding__.__container_class__
    
        container_instance = __initialize_container__
      
      end
    
    end
    
    return container_instance
    
  end

  alias_method( :container, :__container__ )
  
end
