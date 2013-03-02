# -*- encoding : utf-8 -*-

class ::Perspective::Bindings::Container::BindingMethods::ClassBindingMethods <
      ::Perspective::Bindings::Container::BindingMethods

  ###########################
  #  define_binding_getter  #
  ###########################
  
  def define_binding_getter( binding_name )
    
    super
    
    define_class_binding_method_alias( binding_name )
    
  end

  #################################
  #  define_binding_alias_getter  #
  #################################
  
  def define_binding_alias_getter( binding_alias, binding_name )
    
    super

    define_class_binding_method_alias( binding_alias )

  end
  
  ##########################################
  #  define_local_alias_to_binding_getter  #
  ##########################################
  
  def define_local_alias_to_binding_getter( binding_alias, binding_instance )
    
    super

    define_class_binding_method_alias( binding_alias )

  end
  
  #######################################
  #  define_class_binding_method_alias  #
  #######################################
  
  def define_class_binding_method_alias( binding_name )

    #======================#
    #  binding_alias_name  #
    #======================#
    
    existing_method_name = binding_getter_method_name( binding_name )
    alias_method( binding_name.accessor_name, existing_method_name )    
    
  end
  
end
