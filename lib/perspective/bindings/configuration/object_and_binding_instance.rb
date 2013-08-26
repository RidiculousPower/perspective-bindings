# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Configuration::ObjectAndBindingInstance

  extend ::CascadingConfiguration::Setting,
         ::CascadingConfiguration::Hash,
         ::CascadingConfiguration::Array::Unique

  #######################
  #  «binding_aliases»  #
  #######################

	attr_hash  :«binding_aliases»
  
end
