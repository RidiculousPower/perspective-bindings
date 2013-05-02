# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::IncludeExtendForwarding
    
  ###################
  #  self.included  #
  ###################
    
  def self.included( module_or_class_instance )

    module_or_class_instance.module_eval do

      include( ::Perspective::Bindings::IncludeExtendForwarding::InitializeInstances )

    end
    
    super

  end

  ###################
  #  self.extended  #
  ###################

  def self.extended( module_or_class_instance )

    module_or_class_instance.module_eval do

      @child_binding_types = ::Array::Unique.new( self )

    end

    super

  end
  
  ##############
  #  included  #
  ##############
  
  def included( module_instance )

    @child_binding_types.push( module_instance )
    
    super
    
  end

  
  #############
  #  include  #
  #############
  
  def include( *modules )
    
    super
    
    _binding_base = self

    @child_binding_types.each do |this_child_binding_type|
      # append_features hooks via module-cluster
      modules.reverse_each do |this_module|
        if ::Module::Cluster.instance_controller( this_module ).has_stack?( :before_include )
          ::Module::Cluster.evaluate_cluster_stack( :before_include, this_child_binding_type, this_module )
        end
      end
      this_child_binding_type.module_eval { include( _binding_base ) }
      # included hooks for any module
      modules.reverse_each { |this_module| this_module.module_eval { included( this_child_binding_type ) } }
    end
    
    return self
    
  end

  ############
  #  extend  #
  ############

  def extend( *modules )

    super

    @child_binding_types.each do |this_child_binding_type|
      # extend_object hooks via module-cluster
      modules.reverse_each do |this_module|
        if ::Module::Cluster.instance_controller( this_module ).has_stack?( :before_extend )
          ::Module::Cluster.evaluate_cluster_stack( :before_extend, this_child_binding_type, this_module )
        end
      end
      this_child_binding_type.extend( *modules )
      # extended hooks for any module
      modules.reverse_each { |this_module| this_module.module_eval { extended( this_child_binding_type ) } }
    end
    
    return self
    
  end

end
