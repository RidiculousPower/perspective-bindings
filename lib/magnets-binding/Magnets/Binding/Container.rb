
module ::Magnets::Binding::Container
  
	extend ::ModuleCluster

  extend ::Magnets::Binding::Definition
	extend ::Magnets::Binding::Container::Context
  
	include ::Magnets::Binding::Container::ObjectInstance
	include_or_extend_cascades_extends ::Magnets::Binding::Container::ClassInstance

	########################################  Constants  #############################################

  ProhibitedNames = {
    :new => true
  }
  
  RouteDelimiter = '-'

end
