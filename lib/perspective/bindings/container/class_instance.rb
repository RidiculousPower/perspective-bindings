# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Container::ClassInstance
  
  #########
  #  new  #
  #########
  
  ###
  # Ensure that instance bindings initialize prior to calling #initialize.
  #
  # We add this here instead of in #initialize - where it usually would go - so that
  # we can avoid requiring #initialize to call super.
  #
  # As each binding is created, any sub-bindings it has are created. We need the entire tree 
  # to be created first then initialized top-down, otherwise we end up with most-nested bindings 
  # configuring before its parents have initialized. This also tends to cause odd initialization 
  # loops, resulting in configuration happening against a nil container, which is not only wrong 
  # but also quite confusing to debug.
  #
  def new( *args, & block )

    instance_class = self
        
    return allocate.instance_eval do

      ::Module::Cluster.evaluate_cluster_stack( :before_instance, self, instance_class, args, & block )

      «initialize_bindings»
      initialize( *args, & block )
      «initialize_instance»

      ::Module::Cluster.evaluate_cluster_stack( :after_instance, self, instance_class, args, & block )

      return self

    end
    
  end

  #########################
  #  new_nested_instance  #
  #########################
  
  ###
  # When we have a nested object instance we need to ensure that parent configurations are
  #   registered before initialization occurs.
  #
  def new_nested_instance( parent_binding_instance, *args, & block )
        
    instance_class = self
        
    return allocate.instance_eval do

      ::Module::Cluster.evaluate_cluster_stack( :before_instance, self, instance_class, args, & block )

      @«parent_binding» = @«bound_container» = parent_binding_instance      
      ::CascadingConfiguration.replace_parent( self, instance_class, parent_binding_instance )

      «initialize_bindings»
      initialize( *args, & block )
      «initialize_instance»
      
      ::Module::Cluster.evaluate_cluster_stack( :after_instance, self, instance_class, args, & block )
      
      return self

    end
    
  end

end
