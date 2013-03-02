# -*- encoding : utf-8 -*-

class ::Perspective::Bindings::Container::BindingMethods::InstanceBindingMethods <
      ::Perspective::Bindings::Container::BindingMethods

  ####################
  #  define_binding  #
  ####################
  
  def define_binding( binding_name )
  
    super
    
    define_binding_value_getter( binding_name )
    define_binding_value_setter( binding_name )
  
  end

  ##########################
  #  define_binding_alias  #
  ##########################
  
  def define_binding_alias( binding_alias, binding_name )
  
    super
    
    define_binding_alias_value_getter( binding_alias, binding_name )
    define_binding_alias_value_setter( binding_alias, binding_name )
  
  end

  ###################################
  #  define_local_alias_to_binding  #
  ###################################
  
  def define_local_alias_to_binding( binding_alias, binding_instance )
  
    super

    define_local_alias_to_binding_value_getter( binding_alias, binding_name )
    define_local_alias_to_binding_value_setter( binding_alias, binding_name )
  
  end
  
  #################################
  #  define_binding_value_getter  #
  #################################
  
  def define_binding_value_getter( binding_name )
    
    #================#
    #  binding_name  #
    #================#
    
    define_method( binding_name.accessor_name ) do
      
      value = nil
      
      binding = «bindings»[ binding_name ]
      
      # if we have a container return it
      if binding.«container»
        value = binding
      else
        # otherwise return whatever is stored in value
        value = binding.«value»
      end

      return value
      
    end
    
  end

  #################################
  #  define_binding_value_setter  #
  #################################
  
  def define_binding_value_setter( binding_name )
    
    #=================#
    #  binding_name=  #
    #=================#
    
    define_method( binding_name.write_accessor_name ) do |value|

      return «bindings»[ binding_name ].«value» = value
      
    end
    
  end

  #######################################
  #  define_binding_alias_value_getter  #
  #######################################
  
  def define_binding_alias_value_getter( binding_alias, binding_name )
    
    #======================#
    #  binding_alias_name  #
    #======================#
    
    alias_method( binding_alias.accessor_name, binding_name.accessor_name )
    
  end

  #######################################
  #  define_binding_alias_value_setter  #
  #######################################
  
  def define_binding_alias_value_setter( binding_alias, binding_name )
    
    #=======================#
    #  binding_alias_name=  #
    #=======================#
    
    alias_method( binding_alias.write_accessor_name, binding_name.write_accessor_name )
    
  end

  ################################################
  #  define_local_alias_to_binding_value_getter  #
  ################################################

  def define_local_alias_to_binding_value_getter( binding_alias, binding_instance )
    
    #===============================#
    #  local_alias_to_binding_name  #
    #===============================#

    define_method( binding_alias.accessor_name ) do

      return «local_aliases_to_bindings»[ binding_alias ].«value»
      
    end
    
  end

  ################################################
  #  define_local_alias_to_binding_value_setter  #
  ################################################

  def define_local_alias_to_binding_value_setter( binding_alias, binding_instance )
    
    #===============================#
    #  local_alias_to_binding_name  #
    #===============================#

    define_method( binding_alias.write_accessor_name ) do |value|

      return «local_aliases_to_bindings»[ binding_alias ].«value» = value
      
    end
    
  end
  
end
