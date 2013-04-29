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

    instance = allocate
    ::Module::Cluster.evaluate_cluster_stack( :before_instance, instance, self, args, & block )
    instance.initialize«container_instance»( *args, & block )
    ::Module::Cluster.evaluate_cluster_stack( :after_instance, instance, self, args, & block )
        
    return instance
    
  end

  ##########################
  #  new«nested_instance»  #
  ##########################
  
  ###
  # When we have a nested object instance we need to ensure that parent configurations are
  #   registered before initialization occurs.
  #
  def new«nested_instance»( parent_binding_instance, *args, & block )
        
    instance = allocate
    ::CascadingConfiguration.share_configurations( instance, parent_binding_instance )
    ::Module::Cluster.evaluate_cluster_stack( :before_instance, instance, self, args, & block )
    instance.initialize«nested_instance»( parent_binding_instance, *args, & block )
    ::Module::Cluster.evaluate_cluster_stack( :after_instance, instance, self, args, & block )
    
    return instance
    
  end

  ######################################
  #  new«multiple_container_instance»  #
  ######################################
  
  ###
  # When we have a nested object instance we need to ensure that parent configurations are
  #   registered before initialization occurs.
  #
  def new«multiple_container_instance»( parent_binding_instance, *args, & block )
        
    instance = allocate
#    ::CascadingConfiguration.replace_parent( instance, self, parent_binding_instance )
    ::Module::Cluster.evaluate_cluster_stack( :before_instance, instance, self, args, & block )
    instance.initialize«nested_instance»( parent_binding_instance, *args, & block )
    ::Module::Cluster.evaluate_cluster_stack( :after_instance, instance, self, args, & block )
    
    return instance
    
  end

end
