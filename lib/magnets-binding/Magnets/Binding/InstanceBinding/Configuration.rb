
module ::Magnets::Binding::InstanceBinding::Configuration

  include ::CascadingConfiguration::Setting
  
  ########################
  #  parent_binding      #
  #  __parent_binding__  #
  ########################

  attr_reader  :__parent_binding__
  alias_method  :parent_binding, :__parent_binding__

  ##############
  #  view      #
  #  __view__  #
  ##############

  attr_instance_configuration  :__view__
  alias_method  :view, :__view__

  ###############
  #  value      #
  #  __value__  #
  ###############

  attr_reader  :__value__
  alias_method  :value, :__value__
  
end
