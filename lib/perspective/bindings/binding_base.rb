# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::BindingBase

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::ObjectAndBindingInstance

  include ::CascadingConfiguration::Setting
  
  extend ::Perspective::Bindings::IncludeExtend
  
  #######################
  #  «bound_container»  #
  #######################

  attr_reader  :«bound_container»

  ############
  #  «name»  #
  ############
  
  attr_instance_configuration  :«name»

  ############
  #  «root»  #
  ############
  
  attr_reader  :«root»

  ##############
  #  is_root?  #
  ##############
  
  def is_root?
    
    return false
    
  end

  #############
  #  «route»  #
  #############

  attr_instance_configuration  :«route»

  #######################
  #  «route_with_name»  #
  #######################

  attr_instance_configuration  :«route_with_name»

  ####################
  #  «route_string»  #
  ####################

  attr_instance_configuration  :«route_string»

  ##########################
  #  «route_print_string»  #
  ##########################

  attr_instance_configuration  :«route_print_string»

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
