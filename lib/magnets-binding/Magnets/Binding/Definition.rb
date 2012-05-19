
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
    
    define_class_for_class_binding_type( binding_type_name )
    define_class_for_instance_binding_type( binding_type_name, *instance_definition_modules )
    
    define_single_binding_type( binding_type_name )
    define_multiple_binding_type( binding_type_name )
    define_required_single_binding_type( binding_type_name )
    define_required_multiple_binding_type( binding_type_name )
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	#######################################  Method Names  ###########################################

  #########################################
  #  method_name_for_single_binding_type  #
  #########################################
  
  def method_name_for_single_binding_type( binding_type_name )
    
    # attr_[type]
    return 'attr_' << binding_type_name.to_s
    
  end
  
  ###########################################
  #  method_name_for_multiple_binding_type  #
  ###########################################
  
  def method_name_for_multiple_binding_type( binding_type_name )
    
    # attr_[type]s or attr_[types]es
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
    
    # attr_required_[type]
    return 'attr_required_' << binding_type_name.to_s
    
  end
  
  ####################################################
  #  method_name_for_required_multiple_binding_type  #
  ####################################################
  
  def method_name_for_required_multiple_binding_type( binding_type_name )
    
    # attr_required_[type]s or attr_required_[types]es
    method_name = 'attr_required_' << binding_type_name.to_s
    if binding_type_name[ -1 ] =~ /[sx]/
      method_name << 'e'
    end
    method_name << 's'
    
    return method_name
    
  end

	######################################  Define Classes  ##########################################

  #########################################
  #  define_class_for_class_binding_type  #
  #########################################

  def define_class_for_class_binding_type( binding_type_name, *definition_modules )
    
    class_for_class_binding_type = ::Class.new( ::Magnets::Binding::ClassBinding ) do
      
      unless definition_modules.empty?
        include( *definition_modules )
      end
      
    end
    
    multiple_class_for_class_binding_type = ::Class.new( class_for_class_binding_type ) do
      
      include( ::Magnets::Binding::Definition::Multiple )
      
    end
    
    # Class name is ::Magnets::Binding::Types::binding_type_name.to_s.to_camel_case
    camel_case_name = binding_type_name.to_s.to_camel_case
    ::Magnets::Binding::Types.const_set( camel_case_name, class_for_class_binding_type )
    class_for_class_binding_type.const_set( :Multiple, multiple_class_for_class_binding_type )
    
    return class_for_class_binding_type
    
  end

  ############################################
  #  define_class_for_instance_binding_type  #
  ############################################
  
  def define_class_for_instance_binding_type( binding_type_name, *definition_modules )

    instance_binding_class = ::Class.new( ::Magnets::Binding::InstanceBinding ) do
      
      unless definition_modules.empty?
        include( *definition_modules )
      end
      
    end
    
    multiple_instance_binding_class = ::Class.new( instance_binding_class ) do
      
      include( ::Magnets::Binding::Definition::Multiple )
      
    end

    # Assumes class binding type has already been defined.
    camel_case_name = binding_type_name.to_s.to_camel_case
    class_for_class_binding_type = ::Magnets::Binding::Types.const_get( camel_case_name )
    
    # Class name is ::Magnets::Binding::Types::binding_type_name.to_s.to_camel_case::InstanceBinding
    class_for_class_binding_type.const_set( :InstanceBinding, instance_binding_class )
    class_for_class_binding_type::InstanceBinding.const_set( :Multiple, 
                                                             multiple_instance_binding_class )
    
    return instance_binding_class
    
  end

	##########################################  Classes  #############################################

  ##################################
  #  class_for_class_binding_type  #
  ##################################
  
  def class_for_class_binding_type( binding_type_name )
    
    return ::Magnets::Binding::Types.const_get( binding_type_name.to_s.to_camel_case )
    
  end

  #####################################
  #  class_for_instance_binding_type  #
  #####################################

  def class_for_instance_binding_type( binding_type_name )
    
    return class_for_class_binding_type( binding_type_name )::InstanceBinding
    
  end

  ###########################################
  #  class_for_multiple_class_binding_type  #
  ###########################################
  
  def class_for_multiple_class_binding_type( binding_type_name )
    
    return class_for_class_binding_type( binding_type_name )::Multiple
    
  end

  ##############################################
  #  class_for_multiple_instance_binding_type  #
  ##############################################

  def class_for_multiple_instance_binding_type( binding_type_name )
    
    return class_for_instance_binding_type( binding_type_name )::Multiple
    
  end
  
	#######################################  Define Types  ###########################################
  
  ################################
  #  define_single_binding_type  #
  ################################

  def define_single_binding_type( binding_type_name )
    
    method_name = method_name_for_single_binding_type( binding_type_name )
    
    class_for_class_binding_type = class_for_class_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      #===============#
      #  attr_[type]  #
      #===============#
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        new_bindings = [ ]
      
        binding_descriptor_hash = ::Magnets::Binding.parse_binding_declaration_args( *args )

        binding_descriptor_hash.each do |this_binding_name, this_view_class|
          this_new_binding = class_for_class_binding_type.new( this_binding_name, 
                                                               this_view_class, 
                                                               & configuration_proc )
          new_bindings.push( this_new_binding )
        end
        
        return new_bindings
      
      end
      
    end
    
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  def define_multiple_binding_type( binding_type_name )
        
    method_name = method_name_for_multiple_binding_type( binding_type_name )
    
    single_binding_type_method_name = method_name_for_single_binding_type( binding_type_name )
    
    class_multiple_binding_type = class_for_class_binding_type( binding_type_name )::Multiple
    
    self::ClassInstance.module_eval do

      #================#
      #  attr_[type]s  #
      #================#
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        new_bindings = [ ]
      
        binding_descriptor_hash = ::Magnets::Binding.parse_binding_declaration_args( *args )

        binding_descriptor_hash.each do |this_binding_name, this_view_class|
          this_new_binding = class_multiple_binding_type.new( this_binding_name, 
                                                              this_view_class, 
                                                              & configuration_proc )
          new_bindings.push( this_new_binding )
        end
        
        return new_bindings
      
      end
      
    end
    
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  def define_required_single_binding_type( binding_type_name )
        
    method_name = method_name_for_required_single_binding_type( binding_type_name )
    
    single_binding_type_method_name = method_name_for_single_binding_type( binding_type_name )
    
    class_for_class_binding_type = class_for_class_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      #========================#
      #  attr_required_[type]  #
      #========================#
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        new_bindings = __send__( single_binding_type_method_name, *args, & configuration_proc )

        new_bindings.each do |this_binding|
          this_binding.__required__ = true
        end
      
        return new_bindings
      
      end
      
    end
    
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  def define_required_multiple_binding_type( binding_type_name )
    
    method_name = method_name_for_required_multiple_binding_type( binding_type_name )
    
    multiple_binding_type_method_name = method_name_for_multiple_binding_type( binding_type_name )
    
    class_for_class_binding_type = class_for_class_binding_type( binding_type_name )
    
    self::ClassInstance.module_eval do
      
      #=========================#
      #  attr_required_[type]s  #
      #=========================#
      
      define_method( method_name ) do |*args, & configuration_proc|
      
        new_bindings = __send__( multiple_binding_type_method_name, *args, & configuration_proc )
      
        new_bindings.each do |this_binding|
          this_binding.__required__ = true
        end
      
        return new_bindings
      
      end
      
    end
    
  end

end
