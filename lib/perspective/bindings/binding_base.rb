
module ::Perspective::Bindings::BindingBase

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::ObjectAndBindingInstance

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

  ##############
  #  is_root?  #
  ##############
  
  def is_root?
    
    return false
    
  end

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

  #######################
  #  permits_multiple?  #
  #  permits_multiple=  #
  #######################
  
  attr_configuration  :permits_multiple?
  
  self.permits_multiple = false
  
  ###############
  #  required?  #
  #  required=  #
  ###############

  attr_configuration  :required?

  self.required = false

  ###############
  #  optional?  #
  ###############
  
  def optional?
  
    return ! required?
  
  end

  ###############
  #  optional=  #
  ###############
  
  def optional=( true_or_false )
  
    return self.required=( ! true_or_false )
  
  end
  
end
