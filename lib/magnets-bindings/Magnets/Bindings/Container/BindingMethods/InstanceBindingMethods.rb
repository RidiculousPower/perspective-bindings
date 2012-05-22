
module ::Magnets::Bindings::Container::BindingMethods::InstanceBindingMethods
  
  ####################
  #  define_binding  #
  ####################
  
  def define_binding( binding_name )
  
    super
    
    define_binding_value_setter( binding_name )
  
  end

  ##########################
  #  define_binding_alias  #
  ##########################
  
  def define_binding_alias( binding_alias, binding_name )
  
    super
    
    define_binding_alias_value_setter( binding_alias, binding_name )
  
  end

  ###########################
  #  define_shared_binding  #
  ###########################
  
  def define_shared_binding( binding_alias, shared_binding_instance )
    
    super

    define_shared_binding_value_setter( binding_alias, shared_binding_instance )
  
  end

  ####################
  #  remove_binding  #
  ####################

  def remove_binding( binding_name )

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
  
  #################################
  #  define_binding_value_setter  #
  #################################

  # Defines :binding_name=, which sets the value in the binding instance (instance binding only).
  def define_binding_value_setter( binding_name )

    #=================#
    #  binding_name=  #
    #=================#
    
    define_method( binding_name.write_accessor_name ) do |value|
      
      return __bindings__[ binding_name ].__value__ = value
      
    end
    
  end

  #######################################
  #  define_binding_alias_value_setter  #
  #######################################

  def define_binding_alias_value_setter( binding_alias, binding_name )

    #=======================#
    #  binding_alias_name=  #
    #=======================#
    
    define_method( binding_alias.write_accessor_name ) do |value|
      
      return __bindings__[ binding_name ].__value__ = value
      
    end

  end
  
  ########################################
  #  define_shared_binding_value_setter  #
  ########################################

  def define_shared_binding_value_setter( binding_alias, shared_binding_instance )

    #========================#
    #  shared_binding_name=  #
    #========================#
    
    define_method( binding_alias.write_accessor_name ) do |value|
      
      return __shared_bindings__[ binding_alias ].__value__ = value
      
    end

  end
  
end
