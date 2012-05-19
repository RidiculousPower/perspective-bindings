
module ::Magnets::Binding::ClassBinding::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique

  ccm = ::CascadingConfiguration::Methods
    
  ####################
  #  view_class      #
  #  __view_class__  #
  ####################

  attr_instance_configuration  :__view_class__

  ccm.alias_instance_method( self, :view_class, :__view_class__ )

  #############################
  #  configuration_procs      #
  #  __configuration_procs__  #
  #############################
                              
  attr_instance_configuration_unique_array  :__configuration_procs__

  ccm.alias_instance_method( self, :configuration_procs, :__configuration_procs__ )

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  def __configure__( & configuration_proc )
        
    __configuration_procs__.push( configuration_proc )
    
  end

  alias_method( :configure, :__configure__ )

end
