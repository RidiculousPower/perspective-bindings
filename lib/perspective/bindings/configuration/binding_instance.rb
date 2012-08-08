
module ::Perspective::Bindings::Configuration::BindingInstance

  include ::Perspective::Bindings::Configuration::ObjectAndBindingInstance

  include ::CascadingConfiguration::Setting

  ##############
  #  name      #
  #  __name__  #
  ##############
  
  attr_instance_configuration  :__name__

  Controller.alias_instance_method( :name, :__name__ ).to_s

  ###############
  #  route      #
  #  __route__  #
  ###############

  attr_instance_configuration  :__route__

  Controller.alias_instance_method( :route, :__route__ )

  #########################
  #  route_with_name      #
  #  __route_with_name__  #
  #########################

  attr_instance_configuration  :__route_with_name__

  Controller.alias_instance_method( :route_with_name, :__route_with_name__ )

  ######################
  #  route_string      #
  #  __route_string__  #
  ######################

  attr_instance_configuration  :__route_string__

  Controller.alias_instance_method( :route_string, :__route_string__ )

  ############################
  #  route_print_string      #
  #  __route_print_string__  #
  ############################

  attr_configuration  :__route_print_string__

  Controller.alias_instance_method( :route_print_string, :__route_print_string__ )

  self.__route_print_string__ = ::Perspective::Bindings.context_print_string

  ##########################
  #  permits_multiple      #
  #  __permits_multiple__  #
  ##########################
  
  attr_configuration  :permits_multiple? => :__permits_multiple__=

  Controller.alias_instance_method( :permits_multiple=, :__permits_multiple__= )
  
  self.__permits_multiple__ = false
  
  #########################
  #  bound_container      #
  #  __bound_container__  #
  #########################

  attr_reader  :__bound_container__

  alias_method  :bound_container, :__bound_container__

  ###################
  #  required?      #
  #  required=      #
  #  __required__=  #
  ###################

  attr_instance_configuration  :required? => :__required__=

  Controller.alias_instance_method( :required=, :__required__= )

  ###############
  #  optional?  #
  ###############
  
  def optional?
  
    return ! required?
  
  end
  
end
