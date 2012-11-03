
module ::Perspective::Bindings::Configuration::BindingInstance

  include ::Perspective::Bindings::Configuration::ObjectAndBindingInstance

  include ::CascadingConfiguration::Setting

  ##############
  #  __root__  #
  ##############
  
  attr_reader  :__root__

  #####################
  #  __root_string__  #
  #####################

  def __root_string__
    
    # Binding is never root.
    
    return @__root__.__root_string__
    
  end

  ##############
  #  name      #
  #  __name__  #
  ##############
  
  attr_instance_configuration  :__name__

  ###############
  #  route      #
  #  __route__  #
  ###############

  attr_instance_configuration  :__route__

  #########################
  #  route_with_name      #
  #  __route_with_name__  #
  #########################

  attr_instance_configuration  :__route_with_name__

  ######################
  #  route_string      #
  #  __route_string__  #
  ######################

  attr_instance_configuration  :__route_string__

  ############################
  #  route_print_string      #
  #  __route_print_string__  #
  ############################

  attr_instance_configuration  :__route_print_string__

  ##########################
  #  permits_multiple      #
  #  __permits_multiple__  #
  ##########################
  
  attr_configuration  :__permits_multiple__? => :__permits_multiple__=
  
  self.__permits_multiple__ = false
  
  #########################
  #  bound_container      #
  #  __bound_container__  #
  #########################

  attr_reader  :__bound_container__

  ###################
  #  __required__?  #
  #  __required__=  #
  ###################

  attr_instance_configuration  :__required__? => :__required__=

  ###################
  #  __optional__?  #
  ###################
  
  def __optional__?
  
    return ! __required__?
  
  end
  
end
