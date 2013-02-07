
class ::Perspective::Bindings::Container::ObjectAndBindingInstance

  include ::CascadingConfiguration::Hash
  
  ###################################
  #  __local_aliases_to_bindings__  #
  ###################################

	attr_hash  :__local_aliases_to_bindings__ do

	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( local_alias_to_binding, binding_instance, parent_hash )
      
      binding_route = nil
      
      # We are instance C inheriting a shared binding, meaning an alias from instance B to binding in instance A.
      # The inherited binding instance we want already exists in __bindings__ for instance C.
      # We need the nested route for A in B, which will allow us to get A in C.
      
      binding_route = binding_instance.__nested_route__( instance )

      return ::Perspective::Bindings.aliased_binding_in_context( instance, 
                                                                 binding_route,
                                                                 binding_instance.__name__,
                                                                 local_alias_to_binding,
                                                                 binding_instance )

    end
  
  end
  
end
