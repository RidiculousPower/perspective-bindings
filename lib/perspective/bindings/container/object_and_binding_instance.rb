# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Container::ObjectAndBindingInstance

  extend ::CascadingConfiguration::Hash
  
  #################################
  #  «local_aliases_to_bindings»  #
  #################################

	attr_hash  :«local_aliases_to_bindings» do

	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( local_alias_to_binding, binding_instance, parent_hash )
      
      binding_route = nil
      
      # We are instance C inheriting a shared binding, meaning an alias from instance B to binding in instance A.
      # The inherited binding instance we want already exists in «bindings» for instance C.
      # We need the nested route for A in B, which will allow us to get A in C.
      
      binding_route = binding_instance.«nested_route»( instance = configuration_instance )

      return ::Perspective::Bindings.aliased_binding_in_context( instance, 
                                                                 binding_route,
                                                                 binding_instance.«name»,
                                                                 local_alias_to_binding,
                                                                 binding_instance )

    end
  
  end
  
end
