
module ::Magnets::Bindings::Binding::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique
  
  ###############
  #  configure  #
  ###############

  def configure( & configuration_proc )
        
    __configuration_procs__.push( configuration_proc )
    
  end

  # We declare as cascading configurations so that bindings can inherit configurations
  # in parallel with class/module inheritance tree (to which they are bound).
  # Inheritance is accomplished using CascadingConfiguration::Variable functionality;
  # for details, see #initialize.
  
  ####################
  #  __name__        #
  #  __view_class__  #
  ####################
  
  # Identity
  # --------
  # 
  attr_configuration               :__name__, :__view_class__

  ###################
  #  required?      #
  #  __required__=  #
  ###################

  # Constraints
  # -----------
  #
  # Indented listings are sub-constraints from general constraint they are indented below
  # 
  attr_configuration               :required? => :__required__=
  
  ###############
  #  optional?  #
  ###############
  
  def optional?
  
    return ! required?
  
  end
  
  #############################
  #  __configuration_procs__  #
  #############################
                              
  # Configuration
  # -------------
  #
  attr_configuration_unique_array  :__configuration_procs__

  #############################
  #  __route__                #
  #  __bound_module__           #
  #  __sub_bindings__         #
  #  __shared_sub_bindings__  #
  #############################
  
  # Instance-Specific Elements
  # --------------------------
  #
  attr_reader                      :__route__, :__route_string__, 
                                   :__bound_module__, 
                                   :__sub_bindings__, :__shared_sub_bindings__

end
