
module ::Magnets::Bindings::Configuration::BindingInstance

  include ::CascadingConfiguration::Setting

  ccm = ::CascadingConfiguration::Methods

  ##############
  #  name      #
  #  __name__  #
  ##############
  
  attr_instance_configuration  :__name__

  ccm.alias_instance_method( self, :name, :__name__ )

  ###############
  #  route      #
  #  __route__  #
  ###############

  attr_instance_configuration  :__route__

  ccm.alias_instance_method( self, :route, :__route__ )

  #########################
  #  route_with_name      #
  #  __route_with_name__  #
  #########################

  attr_instance_configuration  :__route_with_name__

  ccm.alias_instance_method( self, :route_with_name, :__route_with_name__ )

  ######################
  #  route_string      #
  #  __route_string__  #
  ######################

  attr_instance_configuration  :__route_string__

  ccm.alias_instance_method( self, :route_string, :__route_string__ )

  ############################
  #  route_print_string      #
  #  __route_print_string__  #
  ############################

  attr_configuration  :__route_print_string__

  ccm.alias_instance_method( self, :route_print_string, :__route_print_string__ )

  self.__route_print_string__ = ::Magnets::Bindings.context_print_string

  ##########################
  #  permits_multiple      #
  #  __permits_multiple__  #
  ##########################
  
  attr_configuration  :permits_multiple? => :__permits_multiple__=

  ccm.alias_instance_method( self, :permits_multiple=, :__permits_multiple__= )
  
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

  ccm.alias_instance_method( self, :required=, :__required__= )

  ###############
  #  optional?  #
  ###############
  
  def optional?
  
    return ! required?
  
  end
  
end
