# -*- encoding : utf-8 -*-

class ::Perspective::Bindings::BindingTypeContainer::BindingType::ClassBindingClass < 
      ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingClass
  
  #################################
  #  self.new_inheriting_binding  #
  #################################
  
  def self.new_inheriting_binding( bound_container, ancestor_binding )

    instance = allocate

    ::Module::Cluster.evaluate_cluster_stack( :before_instance, instance, self )

    instance.initialize«inheriting_binding»( bound_container, ancestor_binding )

    ::Module::Cluster.evaluate_cluster_stack( :after_instance, instance, self )
    
    return instance
    
  end
      
  ################
  #  initialize  #
  ################

  def initialize( bound_container, binding_name, *args, & configuration_proc )

    initialize«common_values»( bound_container )
    initialize«new_between_common»( binding_name, *args )
    initialize«common_finalize»

  end

  ####################################
  #  initialize«inheriting_binding»  #
  ####################################

  def initialize«inheriting_binding»( bound_container, ancestor_binding )

    initialize«common_values»( bound_container )
    initialize«inheriting_between_common»( bound_container, ancestor_binding )
    initialize«common_finalize»

  end
  
  ###############################
  #  initialize«common_values»  #
  ###############################

  def initialize«common_values»( bound_container )
    # nothing here - subclasses implement
  end

  ####################################
  #  initialize«new_between_common»  #
  ####################################

  def initialize«new_between_common»( binding_name )
    # nothing here - subclasses implement
  end

  ###########################################
  #  initialize«inheriting_between_common»  #
  ###########################################

  def initialize«inheriting_between_common»( bound_container, ancestor_binding )
    # nothing here - subclasses implement
  end
  
  #################################
  #  initialize«common_finalize»  #
  #################################

  def initialize«common_finalize»( bound_container )
    # nothing here - subclasses implement
  end
  
end
