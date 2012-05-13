
module ::Magnets::Bindings
  
  extend ::Magnets::Bindings::Binding::Definition
	
	include ::Magnets::Bindings::ObjectInstance
	
	extend ::ModuleCluster

	include_or_extend_cascades_extends ::Magnets::Bindings::ClassInstance

  extend ::Magnets::Bindings::BindingContext

  ProhibitedNames = {
    :new => true
  }
  
  RouteDelimiter = '-'

end
