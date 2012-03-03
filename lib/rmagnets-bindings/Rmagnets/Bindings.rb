
module ::Rmagnets::Bindings

  extend ::ModuleCluster

	include ::Rmagnets::Bindings::ObjectInstance
	
	include_cascades_extends_to_class( ::Rmagnets::Bindings::ClassInstance )
	
end
