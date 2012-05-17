
module ::Magnets::Binding::Configuration

  include ::CascadingConfiguration::Setting

  ##############
  #  name      #
  #  __name__  #
  ##############
  
  attr_instance_configuration  :__name__
  alias_method  :name, :__name__
  
  ###################
  #  required?      #
  #  required=      #
  #  __required__=  #
  ###################

  attr_instance_configuration  :required? => :__required__=
  alias_method  :required=, :__required__=
  
  ###############
  #  optional?  #
  ###############
  
  def optional?
  
    return ! required?
  
  end
  
  ###############
  #  route      #
  #  __route__  #
  ###############

  attr_instance_configuration  :__route__
  alias_method  :route, :__route__

  ######################
  #  route_string      #
  #  __route_string__  #
  ######################

  attr_reader  :__route_string__
  alias_method  :route_string, :__route_string__

  ######################
  #  sub_bindings      #
  #  __sub_bindings__  #
  ######################

  attr_reader  :__sub_bindings__
  alias_method  :sub_bindings, :__sub_bindings__

  #############################
  #  shared_sub_bindings      #
  #  __shared_sub_bindings__  #
  #############################
  
  attr_reader  :__shared_sub_bindings__
  alias_method  :shared_sub_bindings, :__shared_sub_bindings__
  
end
