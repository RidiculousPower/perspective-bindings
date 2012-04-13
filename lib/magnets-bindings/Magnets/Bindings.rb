
module ::Magnets::Bindings
	
	include ::Magnets::Bindings::ObjectInstance
	
	extend ::ModuleCluster

	include_or_extend_cascades_extends ::Magnets::Bindings::ClassInstance

  ProhibitedNames = {
    :new => true
  }

end
