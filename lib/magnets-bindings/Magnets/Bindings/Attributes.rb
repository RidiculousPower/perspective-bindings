
module ::Magnets::Bindings::Attributes
  
  #########################
  #  define_binding_type  #
  #########################
  
  def define_binding_type( binding_type_name, *instance_definition_modules )
    
    define_class_binding_class( binding_type_name )
    define_instance_binding_class( binding_type_name, *instance_definition_modules )
    
  end

	##########################################  Classes  #############################################

  #########################
  #  class_binding_class  #
  #########################
  
  def class_binding_class( binding_type_name )
    
    return const_get( binding_type_name.to_s.to_camel_case )
    
  end

  ############################
  #  instance_binding_class  #
  ############################

  def instance_binding_class( binding_type_name )
    
    return class_binding_class( binding_type_name )::InstanceBinding
    
  end

  ##################################
  #  class_multiple_binding_class  #
  ##################################
  
  def class_multiple_binding_class( binding_type_name )
    
    return class_binding_class( binding_type_name )::Multiple
    
  end

  #####################################
  #  instance_multiple_binding_class  #
  #####################################

  def instance_multiple_binding_class( binding_type_name )
    
    return instance_binding_class( binding_type_name )::Multiple
    
  end

	#######################################  Method Names  ###########################################

  ################################
  #  single_binding_method_name  #
  ################################
  
  def single_binding_method_name( binding_type_name )
    
    # attr_[type]
    return 'attr_' << binding_type_name.to_s
    
  end
  
  ##################################
  #  multiple_binding_method_name  #
  ##################################
  
  def multiple_binding_method_name( binding_type_name )
    
    # attr_[type]s or attr_[types]es
    method_name = 'attr_' << binding_type_name.to_s
    if binding_type_name[ -1 ] =~ /[sx]/
      method_name << 'e'
    end
    method_name << 's'
    
    return method_name
    
  end
  
  #########################################
  #  required_single_binding_method_name  #
  #########################################
  
  def required_single_binding_method_name( binding_type_name )
    
    # attr_required_[type]
    return 'attr_required_' << binding_type_name.to_s
    
  end
  
  ###########################################
  #  required_multiple_binding_method_name  #
  ###########################################
  
  def required_multiple_binding_method_name( binding_type_name )
    
    # attr_required_[type]s or attr_required_[types]es
    method_name = 'attr_required_' << binding_type_name.to_s
    if binding_type_name[ -1 ] =~ /[sx]/
      method_name << 'e'
    end
    method_name << 's'
    
    return method_name
    
  end

	######################################  Define Classes  ##########################################

  ################################
  #  define_class_binding_class  #
  ################################

  def define_class_binding_class( binding_type_name, *definition_modules )
    
    class_binding_class = ::Class.new( ::Magnets::Bindings::ClassBinding ) do
      
      unless definition_modules.empty?
        include( *definition_modules.reverse )
      end
      
    end
    
    class_multiple_binding_class = ::Class.new( class_binding_class ) do
      
      include( ::Magnets::Bindings::Attributes::Multiple )
      
    end
    
    # Class name is ::Magnets::Bindings::Types::binding_type_name.to_s.to_camel_case
    camel_case_name = binding_type_name.to_s.to_camel_case
    ::Magnets::Bindings::Types.const_set( camel_case_name, class_binding_class )
    class_binding_class.const_set( :Multiple, class_multiple_binding_class )
    
    return class_binding_class
    
  end

  ###################################
  #  define_instance_binding_class  #
  ###################################
  
  def define_instance_binding_class( binding_type_name, *definition_modules )

    # Assumes class binding type has already been defined.
    camel_case_name = binding_type_name.to_s.to_camel_case
    class_binding_class = ::Magnets::Bindings::Types.const_get( camel_case_name )

    instance_binding_class = ::Class.new( ::Magnets::Bindings::InstanceBinding ) do
      
      unless definition_modules.empty?
        include( *definition_modules.reverse )
      end
      
    end
    
    instance_multiple_binding_class = ::Class.new( instance_binding_class ) do
      
      include( ::Magnets::Bindings::Attributes::Multiple )
      
    end

    
    # Class name is ::Magnets::Bindings::Types::binding_type_name.to_s.to_camel_case::InstanceBinding
    class_binding_class.const_set( :InstanceBinding, instance_binding_class )
    class_binding_class::InstanceBinding.const_set( :Multiple, instance_multiple_binding_class )
    
    return instance_binding_class
    
  end

	##########################################  Classes  #############################################

  #########################
  #  class_binding_class  #
  #########################
  
  def class_binding_class( binding_type_name )
    
    return ::Magnets::Bindings::Types.const_get( binding_type_name.to_s.to_camel_case )
    
  end

  ############################
  #  instance_binding_class  #
  ############################

  def instance_binding_class( binding_type_name )
    
    return class_binding_class( binding_type_name )::InstanceBinding
    
  end

  ##################################
  #  class_multiple_binding_class  #
  ##################################
  
  def class_multiple_binding_class( binding_type_name )
    
    return class_binding_class( binding_type_name )::Multiple
    
  end

  #####################################
  #  instance_multiple_binding_class  #
  #####################################

  def instance_multiple_binding_class( binding_type_name )
    
    return instance_binding_class( binding_type_name )::Multiple
    
  end
  
end
