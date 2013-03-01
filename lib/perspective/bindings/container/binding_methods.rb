# -*- encoding : utf-8 -*-

class ::Perspective::Bindings::Container::BindingMethods <
      ::CascadingConfiguration::InstanceController::SupportModule

  ####################
  #  define_binding  #
  ####################
  
  def define_binding( binding_name )
  
    define_binding_getter( binding_name )
  
  end

  ##########################
  #  define_binding_alias  #
  ##########################
  
  def define_binding_alias( binding_alias, binding_name )
  
    define_binding_alias_getter( binding_alias, binding_name )
  
  end

  ###################################
  #  define_local_alias_to_binding  #
  ###################################
  
  def define_local_alias_to_binding( binding_alias, binding_instance )
  
    define_local_alias_to_binding_getter( binding_alias, binding_instance )
  
  end
  
  ###########################
  #  define_binding_getter  #
  ###########################
  
  # Defines :binding_name, which returns the binding instance (whether class or instance binding).
  def define_binding_getter( binding_name )
    
    #================#
    #  binding_name  #
    #================#
    
    define_method( binding_name ) do

      return «bindings»[ binding_name ]
      
    end
    
  end

  #################################
  #  define_binding_alias_getter  #
  #################################
  
  def define_binding_alias_getter( binding_alias, binding_name )
    
    #======================#
    #  binding_alias_name  #
    #======================#
    
    define_method( binding_alias ) do
      
      return «bindings»[ binding_name ]
      
    end
    
  end

  ##########################################
  #  define_local_alias_to_binding_getter  #
  ##########################################
  
  def define_local_alias_to_binding_getter( binding_alias, binding_instance )
    
    #===============================#
    #  local_alias_to_binding_name  #
    #===============================#

    define_method( binding_alias ) do

      return «local_aliases_to_bindings»[ binding_alias ]
      
    end
    
  end

end
