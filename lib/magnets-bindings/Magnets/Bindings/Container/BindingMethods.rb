
module ::Magnets::Bindings::Container::BindingMethods

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

  ###########################
  #  define_shared_binding  #
  ###########################
  
  def define_shared_binding( binding_alias, shared_binding_instance )
  
    define_shared_binding_getter( binding_alias, shared_binding_instance )
  
  end
  
  ####################
  #  remove_binding  #
  ####################

  def remove_binding( binding_name )

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
      
      return __bindings__[ binding_name ]
      
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
      
      return __bindings__[ binding_alias ]
      
    end
    
  end

  ##################################
  #  define_shared_binding_getter  #
  ##################################
  
  def define_shared_binding_getter( binding_alias, shared_binding_instance )
    
    #=======================#
    #  shared_binding_name  #
    #=======================#

    define_method( binding_alias ) do

      return __shared_bindings__[ binding_alias ]
      
    end
    
  end

end
