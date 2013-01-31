
module ::Perspective::Bindings::BindingBase

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::Configuration::ObjectAndBindingInstance

  include ::CascadingConfiguration::Setting
  
  extend ::Perspective::Bindings::IncludeExtend
  
  #########################
  #  __bound_container__  #
  #########################

  attr_reader  :__bound_container__

  ##############
  #  __name__  #
  ##############
  
  attr_instance_configuration  :__name__

  ##############
  #  __root__  #
  ##############
  
  attr_reader  :__root__

  ###############
  #  __route__  #
  ###############

  attr_instance_configuration  :__route__

  #########################
  #  __route_with_name__  #
  #########################

  attr_instance_configuration  :__route_with_name__

  ######################
  #  __route_string__  #
  ######################

  attr_instance_configuration  :__route_string__

  ############################
  #  __route_print_string__  #
  ############################

  attr_instance_configuration  :__route_print_string__

  ###########################
  #  __permits_multiple__?  #
  #  __permits_multiple__=  #
  ###########################
  
  attr_configuration  :__permits_multiple__?
  
  self.__permits_multiple__ = false
  
  ###################
  #  __required__?  #
  #  __required__=  #
  ###################

  attr_configuration  :__required__?

  self.__required__ = false

  ###################
  #  __optional__?  #
  ###################
  
  def __optional__?
  
    return ! __required__?
  
  end

  ###################
  #  __optional__=  #
  ###################
  
  def __optional__=( true_or_false )
  
    return self.__required__=( ! true_or_false )
  
  end
  
end
