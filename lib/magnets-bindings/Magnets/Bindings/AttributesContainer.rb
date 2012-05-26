
class ::Magnets::Bindings::AttributesContainer < ::Module

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash
  
  MethodPrefix = 'attr'

  ################
  #  initialize  #
  ################
  
  def initialize( parent_container = nil, 
                  class_binding_class = nil, 
                  instance_binding_class = nil,
                  & definition_block )
        
    if class_binding_class
      self.base_class_binding_class = class_binding_class
    end

    if instance_binding_class
      self.base_instance_binding_class = instance_binding_class
    end

    if parent_container
      include parent_container
      ::CascadingConfiguration::Variable.register_child_for_parent( self, parent_container )
      # this will cause the compositing hash to initialize
      # maybe we can move this elsewhere at some point - for now it's a simple solution
      binding_types
    else
      ::CascadingConfiguration::Variable.register_child_for_parent( self, self.class )
    end

    if block_given?
      module_eval( & definition_block )
    end
    
  end

  #########################
  #  define_binding_type  #
  #########################
  
  def define_binding_type( binding_type_name, *instance_definition_modules )
    
    self.binding_types[ binding_type_name ] = instance_definition_modules
    
    define_class_binding_class( binding_type_name )
    define_instance_binding_class( binding_type_name, *instance_definition_modules )
    
    define_binding_methods( binding_type_name )
    
  end

  ###################
  #  binding_types  #
  ###################

  attr_configuration_hash  :binding_types do
    
    #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( binding_type, instance_definition_modules )

	    # We are inheriting types - we have to define our own corresponding classes.
	    configuration_instance.define_binding_type( binding_type, *instance_definition_modules )

	    return instance_definition_modules
	    
    end
    
  end
  
  ##############################
  #  base_class_binding_class  #
  ##############################
  
  attr_configuration  :base_class_binding_class

  self.base_class_binding_class = ::Magnets::Bindings::ClassBinding
  
  #################################
  #  base_instance_binding_class  #
  #################################
  
  attr_configuration  :base_instance_binding_class

  self.base_instance_binding_class = ::Magnets::Bindings::InstanceBinding
  
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

	######################################  Define Classes  ##########################################

  ################################
  #  define_class_binding_class  #
  ################################

  def define_class_binding_class( binding_type_name, *definition_modules )

    class_binding_class = ::Class.new( base_class_binding_class ) do

      unless definition_modules.empty?
        include( *definition_modules.reverse )
      end
      
      self.__type__ = binding_type_name
      
    end
    
    class_multiple_binding_class = ::Class.new( class_binding_class ) do
      
      include( ::Magnets::Bindings::Attributes::Multiple )
      
    end
    
    # Class name is self::binding_type_name.to_s.to_camel_case
    camel_case_name = binding_type_name.to_s.to_camel_case
    
    const_set( camel_case_name, class_binding_class )
    class_binding_class.const_set( :Multiple, class_multiple_binding_class )
    
    return class_binding_class
    
  end

  ###################################
  #  define_instance_binding_class  #
  ###################################
  
  def define_instance_binding_class( binding_type_name, *definition_modules )

    # Assumes class binding type has already been defined.
    camel_case_name = binding_type_name.to_s.to_camel_case
    class_binding_class = const_get( camel_case_name )

    instance_binding_class = ::Class.new( base_instance_binding_class ) do
      
      unless definition_modules.empty?
        include( *definition_modules.reverse )
      end
    
      self.__type__ = binding_type_name
      
    end
    
    instance_multiple_binding_class = ::Class.new( instance_binding_class ) do
      
      include( ::Magnets::Bindings::Attributes::Multiple )
      
    end

    
    # Class name is self::binding_type_name.to_s.to_camel_case::InstanceBinding
    class_binding_class.const_set( :InstanceBinding, instance_binding_class )
    class_binding_class::InstanceBinding.const_set( :Multiple, instance_multiple_binding_class )
    
    return instance_binding_class
    
  end

	######################################  Define Methods  ##########################################

  ############################
  #  define_binding_methods  #
  ############################
  
  def define_binding_methods( binding_method_name, binding_type_name = binding_method_name )
        
    define_single_binding_type( binding_method_name, binding_type_name )
    define_multiple_binding_type( binding_method_name, binding_type_name )
    define_required_single_binding_type( binding_method_name, binding_type_name )
    define_required_multiple_binding_type( binding_method_name, binding_type_name )
    
  end

  ################################
  #  single_binding_method_name  #
  ################################
  
  def single_binding_method_name( binding_type_name )
    
    # attr_[type]
    
    method_prefix = ::Magnets::Bindings::AttributesContainer::MethodPrefix.dup
    
    return method_prefix << '_' << binding_type_name.to_s
    
  end
  
  ##################################
  #  multiple_binding_method_name  #
  ##################################
  
  def multiple_binding_method_name( binding_type_name )
    
    method_prefix = ::Magnets::Bindings::AttributesContainer::MethodPrefix.dup
    
    # attr_[type]s or attr_[types]es
    method_name = method_prefix << '_' << binding_type_name.to_s
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
    
    method_prefix = ::Magnets::Bindings::AttributesContainer::MethodPrefix.dup
    
    # attr_required_[type]
    return method_prefix << '_required_' << binding_type_name.to_s
    
  end
  
  ###########################################
  #  required_multiple_binding_method_name  #
  ###########################################
  
  def required_multiple_binding_method_name( binding_type_name )
    
    method_prefix = ::Magnets::Bindings::AttributesContainer::MethodPrefix.dup
    
    # attr_required_[type]s or attr_required_[types]es
    method_name = method_prefix << '_required_' << binding_type_name.to_s
    if binding_type_name[ -1 ] =~ /[sx]/
      method_name << 'e'
    end
    method_name << 's'
    
    return method_name
    
  end

  ################################
  #  define_single_binding_type  #
  ################################

  def define_single_binding_type( binding_method_name, binding_type_name = binding_method_name )
    
    method_name = single_binding_method_name( binding_method_name )
    
    class_binding_class = class_binding_class( binding_type_name )
    
    #===============#
    #  attr_[type]  #
    #===============#
    
    define_method( method_name ) do |*args, & configuration_proc|
    
      new_bindings = [ ]
    
      binding_descriptor_hash = ::Magnets::Bindings.parse_binding_declaration_args( *args )

      binding_descriptor_hash.each do |this_binding_name, this_container_class|
        this_new_binding = class_binding_class.new( this_binding_name, 
                                                    this_container_class, 
                                                    & configuration_proc )
        new_bindings.push( this_new_binding )
        __bindings__[ this_binding_name ] = this_new_binding
        this_new_binding.__bound_container_class__ = self
        self::ClassBindingMethods.define_binding( this_binding_name )
        self::InstanceBindingMethods.define_binding( this_binding_name )
      end
      
      return new_bindings
    
    end
    
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  def define_multiple_binding_type( binding_method_name, binding_type_name = binding_method_name )
        
    method_name = multiple_binding_method_name( binding_method_name )
    
    single_binding_method_name = single_binding_method_name( binding_method_name )
    
    class_multiple_binding = class_binding_class( binding_type_name )::Multiple
    
    #================#
    #  attr_[type]s  #
    #================#
    
    define_method( method_name ) do |*args, & configuration_proc|
    
      new_bindings = [ ]
    
      binding_descriptor_hash = ::Magnets::Bindings.parse_binding_declaration_args( *args )

      binding_descriptor_hash.each do |this_binding_name, this_container_class|
        this_new_binding = class_multiple_binding.new( this_binding_name, 
                                                       this_container_class, 
                                                       & configuration_proc )
        new_bindings.push( this_new_binding )
        __bindings__[ this_binding_name ] = this_new_binding
        this_new_binding.__bound_container_class__ = self
        self::ClassBindingMethods.define_binding( this_binding_name )
        self::InstanceBindingMethods.define_binding( this_binding_name )
      end
      
      return new_bindings
    
    end
    
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  def define_required_single_binding_type( binding_method_name, 
                                           binding_type_name = binding_method_name )
        
    method_name = required_single_binding_method_name( binding_method_name )
    
    single_binding_method_name = single_binding_method_name( binding_method_name )
    
    class_binding_class = class_binding_class( binding_type_name )
    
    #========================#
    #  attr_required_[type]  #
    #========================#
    
    define_method( method_name ) do |*args, & configuration_proc|
    
      new_bindings = __send__( single_binding_method_name, *args, & configuration_proc )

      new_bindings.each do |this_binding|
        this_binding.__required__ = true
      end
    
      return new_bindings
    
    end
    
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  def define_required_multiple_binding_type( binding_method_name, 
                                             binding_type_name = binding_method_name )
    
    method_name = required_multiple_binding_method_name( binding_method_name )
    
    multiple_binding_method_name = multiple_binding_method_name( binding_method_name )
    
    class_binding_class = class_binding_class( binding_type_name )
    
    #=========================#
    #  attr_required_[type]s  #
    #=========================#
    
    define_method( method_name ) do |*args, & configuration_proc|
    
      new_bindings = __send__( multiple_binding_method_name, *args, & configuration_proc )
    
      new_bindings.each do |this_binding|
        this_binding.__required__ = true
      end
    
      return new_bindings
    
    end
    
  end

end
