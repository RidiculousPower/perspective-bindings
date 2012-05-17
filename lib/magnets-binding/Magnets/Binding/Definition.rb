
module ::Magnets::Binding::Definition
  
  ##################################################################################################
  #                                                                                                #
  #  This module assumes that the module it extends has a module self::ClassInstance.              #
  #                                                                                                #
  #  This allows us to use it in multiple places, defining bindings only where they belong:        #
  #                                                                                                #
  #  * Magnets::Binding::Container                                                                 #
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
  
  def define_binding_type( binding_type_name, *instance_definition_modules )
    
    define_class_binding_type( binding_type_name )
    define_instance_binding_type( binding_type_name, *instance_definition_modules )
    
    define_single_binding_type( binding_type_name )
    define_multiple_binding_type( binding_type_name )
    define_required_single_binding_type( binding_type_name )
    define_required_multiple_binding_type( binding_type_name )
    
  end

  ###############################
  #  define_class_binding_type  #
  ###############################

  def define_class_binding_type( binding_type_name, *definition_modules )
    
    class_binding_type = ::Class.new( ::Magnets::Binding::ClassBinding ) do
      
      unless definition_modules.empty?
        include( *definition_modules )
      end
      
    end
    
    # Class name is ::Magnets::Binding::Types::binding_type_name.to_camel_case
    ::Magnets::Binding::Types.const_set( binding_type_name.to_camel_case, class_binding_type )
    
    return class_binding_type
    
  end

  ##################################
  #  define_instance_binding_type  #
  ##################################
  
  def define_instance_binding_type( binding_type_name, *definition_modules )

    instance_binding_type = ::Class.new( ::Magnets::Binding::InstanceBinding ) do
      
      unless definition_modules.empty?
        include( *definition_modules )
      end
      
    end
    
    multiple_instance_binding_type = ::Class.new( instance_binding_type ) do
      
      include( ::Magnets::Binding::Definition::Multiple )
      
    end

    # Assumes class binding type has already been defined.
    class_binding_type = ::Magnets::Binding::Types.const_get( binding_type_name.to_camel_case )
    
    # Class name is ::Magnets::Binding::Types::binding_type_name.to_camel_case::InstanceBinding
    class_binding_type.const_set( :InstanceBinding, instance_binding_type )
    class_binding_type::InstanceBinding.const_set( :Multiple, multiple_instance_binding_type )
    
    return instance_binding_type
    
  end
  
  ########################
  #  class_binding_type  #
  ########################
  
  def class_binding_type( binding_type_name )
    
    return ::Magnets::Binding::Types.const_get( binding_type_name.to_camel_case )
    
  end

  ###########################
  #  instance_binding_type  #
  ###########################

  def instance_binding_type( binding_type_name )
    
    return class_binding_type( binding_type_name )::InstanceBinding
    
  end
  
  ################################
  #  define_single_binding_type  #
  ################################

  def define_single_binding_type( binding_type_name )
    
    method_name = method_name_for_single_binding_type( binding_type_name )
    
    class_binding_type = class_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        bindings = __create_bindings_for_args__( class_binding_type, 
                                                 false, 
                                                 *args, 
                                                 & configuration_proc )
      
      end
      
    end
    
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  def define_multiple_binding_type( binding_type_name )
        
    method_name = method_name_for_multiple_binding_type( binding_type_name )
    
    class_binding_type = class_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        bindings = __create_bindings_for_args__( class_binding_type, 
                                                 true, 
                                                 *args, 
                                                 & configuration_proc )
      
        return bindings
      
      end
      
    end
    
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  def define_required_single_binding_type( binding_type_name )
        
    method_name = method_name_for_required_single_binding_type( binding_type_name )
    
    class_binding_type = class_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        bindings = __create_bindings_for_args__( class_binding_type, 
                                                 false, 
                                                 *args, 
                                                 & configuration_proc )
      
        bindings.each do |this_binding|
          this_binding.__required__ = true
        end
      
        return bindings
      
      end
      
    end
    
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  def define_required_multiple_binding_type( binding_type_name )
    
    method_name = method_name_for_required_multiple_binding_type( binding_type_name )
    
    class_binding_type = class_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        bindings = __create_bindings_for_args__( class_binding_type, 
                                                 true, 
                                                 *args, 
                                                 & configuration_proc )
      
        bindings.each do |this_binding|
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
