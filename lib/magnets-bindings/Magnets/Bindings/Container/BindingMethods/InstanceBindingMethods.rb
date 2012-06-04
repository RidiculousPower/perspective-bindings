
module ::Magnets::Bindings::Container::BindingMethods::InstanceBindingMethods
  
  ####################
  #  define_binding  #
  ####################
  
  def define_binding( binding_name )
  
    define_binding_value_setter( binding_name )
    define_binding_value_getter( binding_name )

    define_binding_view_setter( binding_name )
    define_binding_view_getter( binding_name )
  
  end

  ##########################
  #  define_binding_alias  #
  ##########################
  
  def define_binding_alias( binding_alias, binding_name )
  
    define_binding_alias_value_setter( binding_alias, binding_name )
    define_binding_alias_value_getter( binding_alias, binding_name )

    define_binding_alias_view_setter( binding_alias, binding_name )
    define_binding_alias_view_getter( binding_alias, binding_name )
  
  end

  ###########################
  #  define_shared_binding  #
  ###########################
  
  def define_shared_binding( binding_alias, shared_binding_instance )
    
    define_shared_binding_value_setter( binding_alias, shared_binding_instance )
    define_shared_binding_value_getter( binding_alias, shared_binding_instance )

    define_shared_binding_view_setter( binding_alias, shared_binding_instance )
    define_shared_binding_view_getter( binding_alias, shared_binding_instance )
  
  end

  ####################
  #  remove_binding  #
  ####################

  def remove_binding( binding_name )

  end

  ########################################
  #  view_binding_name_for_binding_name  #
  ########################################

  def view_binding_name_for_binding_name( binding_name )
    
    return ( binding_name.to_s + '_view' ).to_sym
    
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

  #################################
  #  define_binding_value_setter  #
  #################################

  # Defines :binding_name=, which sets the value in the binding instance (instance binding only).
  def define_binding_value_getter( binding_name )

    #================#
    #  binding_name  #
    #================#
    
    define_method( binding_name ) do
      
      return __bindings__[ binding_name ].__value__
      
    end
    
  end

  ################################
  #  define_binding_view_setter  #
  ################################

  # Defines :binding_name=, which sets the view in the binding instance (instance binding only).
  def define_binding_view_setter( binding_name )

    #=================#
    #  binding_name=  #
    #=================#
    
    view_binding_method_name = view_binding_name_for_binding_name( binding_name )
    
    define_method( view_binding_method_name.write_accessor_name ) do |view|
      
      return __bindings__[ binding_name ].__view__ = view
      
    end
    
  end

  ################################
  #  define_binding_view_setter  #
  ################################

  # Defines :binding_name=, which sets the view in the binding instance (instance binding only).
  def define_binding_view_getter( binding_name )

    #================#
    #  binding_name  #
    #================#
    
    define_method( view_binding_name_for_binding_name( binding_name ) ) do
      
      return __bindings__[ binding_name ].__view__
      
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

  #######################################
  #  define_binding_alias_value_getter  #
  #######################################

  def define_binding_alias_value_getter( binding_alias, binding_name )

    #======================#
    #  binding_alias_name  #
    #======================#
    
    define_method( binding_alias ) do
      
      return __bindings__[ binding_name ].__value__
      
    end

  end
  
  ######################################
  #  define_binding_alias_view_setter  #
  ######################################

  def define_binding_alias_view_setter( binding_alias, binding_name )

    #=======================#
    #  binding_alias_name=  #
    #=======================#
    
    view_binding_method_name = view_binding_name_for_binding_name( binding_alias )
    
    define_method( view_binding_method_name.write_accessor_name ) do |view|
      
      return __bindings__[ binding_name ].__view__ = view
      
    end

  end

  ######################################
  #  define_binding_alias_view_getter  #
  ######################################

  def define_binding_alias_view_getter( binding_alias, binding_name )

    #======================#
    #  binding_alias_name  #
    #======================#
    
    define_method( view_binding_name_for_binding_name( binding_alias ) ) do
      
      return __bindings__[ binding_name ].__view__
      
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

  ########################################
  #  define_shared_binding_value_getter  #
  ########################################
  
  def define_shared_binding_value_getter( binding_alias, shared_binding_instance )
    
    #=======================#
    #  shared_binding_name  #
    #=======================#
    
    define_method( binding_alias ) do
      
      return __shared_bindings__[ binding_alias ].__value__
      
    end
    
  end
  
  #######################################
  #  define_shared_binding_view_setter  #
  #######################################

  def define_shared_binding_view_setter( binding_alias, shared_binding_instance )

    #========================#
    #  shared_binding_name=  #
    #========================#
    
    view_binding_method_name = view_binding_name_for_binding_name( binding_alias )
    
    define_method( view_binding_method_name.write_accessor_name ) do |view|
      
      return __shared_bindings__[ binding_alias ].__view__ = view
      
    end

  end

  #######################################
  #  define_shared_binding_view_getter  #
  #######################################
  
  def define_shared_binding_view_getter( binding_alias, shared_binding_instance )
    
    #=======================#
    #  shared_binding_name  #
    #=======================#
    
    define_method( view_binding_name_for_binding_name( binding_alias ) ) do
      
      return __shared_bindings__[ binding_alias ].__view__
      
    end
    
  end
  
end
