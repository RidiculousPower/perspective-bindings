
module ::Magnets::Bindings
	
	include ::Magnets::Bindings::ObjectInstance
	
	extend ::ModuleCluster

	include_or_extend_cascades_extends ::Magnets::Bindings::ClassInstance

  extend ::Magnets::Bindings::BindingContext

  ProhibitedNames = {
    :new => true
  }
  
  RouteDelimiter = '-'

end
