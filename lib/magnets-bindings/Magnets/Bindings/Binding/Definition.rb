
module ::Magnets::Bindings::Binding::Definition
  
  ##################################################################################################
  #                                                                                                #
  #  This module assumes that the module it extends has a module self::ClassInstance.              #
  #                                                                                                #
  #  This allows us to use it in multiple places, defining bindings only where they belong:        #
  #                                                                                                #
  #  * Magnets::Bindings                                                                           #
  #  * Magnets::View                                                                               #
  #  * Magnets::ViewModel                                                                          #
  #  * Magnets::Form                                                                               #
  #                                                                                                #
  #  Magnets::Bindings.define_binding_type( :name, *modules ), defines binding type for all        #
  #  Bindings inheritors, whereas Magnets::Form.define_binding_type( :name, *modules ), defines    #
  #  it only for Form inheritors.                                                                  #
  #                                                                                                #
  ##################################################################################################
  
  #########################
  #  define_binding_type  #
  #########################
  
  def define_binding_type( binding_type_name, *definition_modules )
    
    define_single_binding_type( binding_type_name, *definition_modules )
    define_multiple_binding_type( binding_type_name, *definition_modules )
    define_required_single_binding_type( binding_type_name, *definition_modules )
    define_required_multiple_binding_type( binding_type_name, *definition_modules )
    
  end

  ################################
  #  define_single_binding_type  #
  ################################

  def define_single_binding_type( binding_type_name, *definition_modules )
    
    method_name = method_name_for_single_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        bindings = __create_bindings_for_args__( *args, & configuration_proc )
      
        bindings.each do |this_binding|
          this_binding.extend( *definition_modules )
        end
      
        return bindings
      
      end
      
    end
    
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  def define_multiple_binding_type( binding_type_name, *definition_modules )
        
    method_name = method_name_for_multiple_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        bindings = __create_bindings_for_args__( *args, & configuration_proc )
      
        bindings.each do |this_binding|
          this_binding.extend( ::Magnets::Bindings::Binding::Definition::Multiple,
                               *definition_modules )
        end
      
        return bindings
      
      end
      
    end
    
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  def define_required_single_binding_type( binding_type_name, *definition_modules )
        
    method_name = method_name_for_required_single_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        bindings = __create_bindings_for_args__( *args, & configuration_proc )
      
        bindings.each do |this_binding|
          this_binding.extend( *definition_modules )
          this_binding.__required__ = true
        end
      
        return bindings
      
      end
      
    end
    
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  def define_required_multiple_binding_type( binding_type_name, *definition_modules )
    
    method_name = method_name_for_required_multiple_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        bindings = __create_bindings_for_args__( *args, & configuration_proc )
      
        bindings.each do |this_binding|
          this_binding.extend( ::Magnets::Bindings::Binding::Definition::Multiple, 
                               *definition_modules )
          this_binding.__required__ = true
        end
      
        return bindings
      
      end
      
    end
    
  end
  
  #########################################
  #  method_name_for_single_binding_type  #
  #########################################
  
  def method_name_for_single_binding_type( binding_type_name )
    
    # attr_[name]
    return 'attr_' << binding_type_name.to_s
    
  end
  
  ###########################################
  #  method_name_for_multiple_binding_type  #
  ###########################################
  
  def method_name_for_multiple_binding_type( binding_type_name )
    
    # attr_[name]s or attr_[names]es
    method_name = 'attr_' << binding_type_name.to_s
    if binding_type_name[ -1 ] =~ /[sx]/
      method_name << 'e'
    end
    method_name << 's'
    
    return method_name
    
  end
  
  ##################################################
  #  method_name_for_required_single_binding_type  #
  ##################################################
  
  def method_name_for_required_single_binding_type( binding_type_name )
    
    # attr_required_[name]
    return 'attr_required_' << binding_type_name.to_s
    
  end
  
  ####################################################
  #  method_name_for_required_multiple_binding_type  #
  ####################################################
  
  def method_name_for_required_multiple_binding_type( binding_type_name )
    
    # attr_required_[name]s or attr_required_[names]es
    method_name = 'attr_required_' << binding_type_name.to_s
    if binding_type_name[ -1 ] =~ /[sx]/
      method_name << 'e'
    end
    method_name << 's'
    
    return method_name
    
  end
  
end
