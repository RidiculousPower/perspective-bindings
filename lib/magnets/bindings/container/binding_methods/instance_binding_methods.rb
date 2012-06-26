
class ::Magnets::Bindings::Container::BindingMethods::InstanceBindingMethods < 
      ::Magnets::Bindings::Container::BindingMethods
  
  ####################
  #  define_binding  #
  ####################
  
  def define_binding( binding_name )
  
    define_binding_getter( binding_name )
    
    define_binding_value_setter( binding_name )
    define_binding_value_getter( binding_name )

    define_binding_view_setter( binding_name )
    define_binding_view_getter( binding_name )
  
  end

  ##########################
  #  define_binding_alias  #
  ##########################
  
  def define_binding_alias( binding_alias, binding_name )
  
    define_binding_alias_getter( binding_alias, binding_name )
    
    define_binding_alias_value_setter( binding_alias, binding_name )
    define_binding_alias_value_getter( binding_alias, binding_name )

    define_binding_alias_view_setter( binding_alias, binding_name )
    define_binding_alias_view_getter( binding_alias, binding_name )
  
  end

  ###########################
  #  define_local_alias_to_binding  #
  ###########################
  
  def define_local_alias_to_binding( binding_alias, binding_instance )
    
    define_local_alias_to_binding_getter( binding_alias, binding_instance )
    
    define_local_alias_to_binding_value_setter( binding_alias, binding_instance )
    define_local_alias_to_binding_value_getter( binding_alias, binding_instance )

    define_local_alias_to_binding_view_setter( binding_alias, binding_instance )
    define_local_alias_to_binding_view_getter( binding_alias, binding_instance )
  
  end

  ####################
  #  remove_binding  #
  ####################

  def remove_binding( binding_name )

  end

  ########################################
  #  view_method_name_for_binding_name  #
  ########################################

  def view_method_name_for_binding_name( binding_name )
    
    return ( binding_name.to_s << '_view' ).to_sym
    
  end
  
  ##########################################
  #  binding_method_name_for_binding_name  #
  ##########################################
  
  def binding_method_name_for_binding_name( binding_name )
    
    return ( binding_name.to_s << '_binding' ).to_sym
    
  end

  ###########################
  #  define_binding_getter  #
  ###########################

  # Defines :binding_name_binding, which gets the binding instance (instance binding only).
  def define_binding_getter( binding_name )

    #========================#
    #  binding_name_binding  #
    #========================#
    
    define_method( binding_method_name_for_binding_name( binding_name ) ) do
      
      return __bindings__[ binding_name ]
      
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

    #======================#
    #  binding_name_view=  #
    #======================#
    
    view_binding_method_name = view_method_name_for_binding_name( binding_name )
    
    define_method( view_binding_method_name.write_accessor_name ) do |view|
      
      return __bindings__[ binding_name ].__view__ = view
      
    end
    
  end

  ################################
  #  define_binding_view_setter  #
  ################################

  # Defines :binding_name=, which sets the view in the binding instance (instance binding only).
  def define_binding_view_getter( binding_name )

    #=====================#
    #  binding_name_view  #
    #=====================#
    
    define_method( view_method_name_for_binding_name( binding_name ) ) do

      return __bindings__[ binding_name ].__view__
      
    end
    
  end

  #################################
  #  define_binding_alias_getter  #
  #################################

  # Defines :binding_name_binding, which gets the binding instance (instance binding only).
  def define_binding_alias_getter( binding_alias, binding_name )

    #========================#
    #  binding_name_binding  #
    #========================#
    
    define_method( binding_method_name_for_binding_name( binding_alias ) ) do
      
      return __bindings__[ binding_name ]
      
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
    
    view_binding_method_name = view_method_name_for_binding_name( binding_alias )
    
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
    
    define_method( view_method_name_for_binding_name( binding_alias ) ) do
      
      return __bindings__[ binding_name ].__view__
      
    end

  end
  
  ##########################################
  #  define_local_alias_to_binding_getter  #
  ##########################################

  # Defines :binding_name_binding, which gets the binding instance (instance binding only).
  def define_local_alias_to_binding_getter( binding_alias, binding_instance )

    #========================#
    #  binding_name_binding  #
    #========================#
    
    define_method( binding_method_name_for_binding_name( binding_alias ) ) do
      
      return __local_aliases_to_bindings__[ binding_alias ]
      
    end
    
  end
  
  ################################################
  #  define_local_alias_to_binding_value_setter  #
  ################################################

  def define_local_alias_to_binding_value_setter( binding_alias, binding_instance )

    #================================#
    #  local_alias_to_binding_name=  #
    #================================#
    
    define_method( binding_alias.write_accessor_name ) do |value|

      return __local_aliases_to_bindings__[ binding_alias ].__value__ = value
      
    end

  end

  ################################################
  #  define_local_alias_to_binding_value_getter  #
  ################################################
  
  def define_local_alias_to_binding_value_getter( binding_alias, binding_instance )
    
    #===============================#
    #  local_alias_to_binding_name  #
    #===============================#
    
    define_method( binding_alias ) do
      
      return __local_aliases_to_bindings__[ binding_alias ].__value__
      
    end
    
  end
  
  ###############################################
  #  define_local_alias_to_binding_view_setter  #
  ###############################################

  def define_local_alias_to_binding_view_setter( binding_alias, binding_instance )

    #================================#
    #  local_alias_to_binding_name=  #
    #================================#
    
    view_binding_method_name = view_method_name_for_binding_name( binding_alias )
    
    define_method( view_binding_method_name.write_accessor_name ) do |view|
      
      return __local_aliases_to_bindings__[ binding_alias ].__view__ = view
      
    end

  end

  ###############################################
  #  define_local_alias_to_binding_view_getter  #
  ###############################################
  
  def define_local_alias_to_binding_view_getter( binding_alias, binding_instance )
    
    #===============================#
    #  local_alias_to_binding_name  #
    #===============================#
    
    define_method( view_method_name_for_binding_name( binding_alias ) ) do
      
      return __local_aliases_to_bindings__[ binding_alias ].__view__
      
    end
    
  end
  
end
