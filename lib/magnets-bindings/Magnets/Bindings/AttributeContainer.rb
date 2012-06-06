
class ::Magnets::Bindings::AttributeContainer < ::Module

  MethodPrefix = 'attr'

  ################
  #  initialize  #
  ################
  
  def initialize( store_in_container = nil, 
                  name = nil, 
                  parent_container = nil, 
                  & definition_block )

    if store_in_container
      store_in_container.const_set( name.to_s.to_camel_case, self )
    end
    
    initialize_binding_extension_modules( parent_container )
    
    @binding_types = { }
    @binding_aliases = { }

    initialize_for_parents( parent_container )
    
    if block_given?
      module_eval( & definition_block )
    end
    
  end

  ############################
  #  initialize_for_parents  #
  ############################

  def initialize_for_parents( parent_container )
    
    # We store parents in a unique array so that we retain initial sort order.
    #
    # This forces the same behavior as the Ruby ancestor chain - with the exception of
    # re-including, which is not managed. So long as new parents are only added once, only new
    # parents will be added to the chain, and in the order parents are added.
    # 
    # This should be all we need to permit multiple parents.
    # 
    @parents ||= ::CompositingArray::Unique.new( nil, self )
    
    if parent_container

      include parent_container

      if parents_of_parent = parent_container.parents
        @parents.concat( parents_of_parent )
      end

      @parents.push( parent_container )

      parent_container.binding_types.each do |this_binding_type, these_instance_extension_modules|
        define_binding_type( this_binding_type )
      end

      parent_container.binding_aliases.each do |this_binding_alias, this_binding_type|
        alias_binding_type( this_binding_alias, this_binding_type )
      end

    end
    
    return @parents
    
  end
  
  ##########################################
  #  initialize_binding_extension_modules  #
  ##########################################
  
  def initialize_binding_extension_modules( parent_container = nil )
    
    # Define extension modules for class and instance bindings.
    # These always live at ::Magnets::Bindings::AttributeContainers::ContainerName::ClassBinding 
    # and ::Magnets::Bindings::AttributeContainers::ContainerName::InstanceBinding.
    
    class_binding_extension_module = ::Module.new do

      # Causes module inclusion to forward to any including modules.
      # This is to get around Ruby's dynamic include problem.
      extend ::Magnets::Bindings::AttributeDefinitionModule

      if parent_container
        include parent_container::ClassBinding
      end

    end

    multiple_class_binding_extension_module = ::Module.new do

      # Causes module inclusion to forward to any including modules.
      # This is to get around Ruby's dynamic include problem.
      extend ::Magnets::Bindings::AttributeDefinitionModule

      if parent_container
        include parent_container::ClassBinding::Multiple
      end

    end
    
    const_set( :ClassBinding, class_binding_extension_module )

    class_binding_extension_module.const_set( :Multiple, multiple_class_binding_extension_module )
    
    instance_binding_extension_module = ::Module.new do
      
      # Causes module inclusion to forward to any including modules.
      # This is to get around Ruby's dynamic include problem.
      extend ::Magnets::Bindings::AttributeDefinitionModule
      
      if parent_container
        include parent_container::InstanceBinding
      end
      
    end
    
    multiple_instance_binding_extension_module = ::Module.new do
      
      # Causes module inclusion to forward to any including modules.
      # This is to get around Ruby's dynamic include problem.
      extend ::Magnets::Bindings::AttributeDefinitionModule

      if parent_container
        include parent_container::InstanceBinding::Multiple
      end

    end
    
    const_set( :InstanceBinding, instance_binding_extension_module ) 
    instance_binding_extension_module.const_set( :Multiple, multiple_instance_binding_extension_module )
    
  end

  #############
  #  parents  #
  #############
  
  attr_reader :parents

  ###################
  #  binding_types  #
  ###################
  
  attr_reader :binding_types

  #####################
  #  binding_aliases  #
  #####################
  
  attr_reader :binding_aliases

  #################################
  #  instance_binding_extensions  #
  #################################

  def instance_binding_extensions( binding_type_name )
    
    return @binding_types[ binding_type_name ]
    
  end

  #########################
  #  define_binding_type  #
  #########################
  
  def define_binding_type( binding_type_name, *instance_definition_modules )
    
    @binding_types[ binding_type_name ] ||= [ ]
    @binding_types[ binding_type_name ].concat( instance_definition_modules )
    
    class_binding_class = define_class_binding_class( binding_type_name )
    instance_binding_class = define_instance_binding_class( binding_type_name, 
                                                            *instance_definition_modules )
    
    define_binding_methods( binding_type_name )
    
    return class_binding_class
    
  end

  ########################
  #  alias_binding_type  #
  ########################
  
  def alias_binding_type( alias_name, binding_type_name )
    
    @binding_aliases[ alias_name ] = binding_type_name
    
    define_binding_methods( alias_name, binding_type_name )
    
  end
  
  #########################
  #  extend_binding_type  #
  #########################
  
  def extend_binding_type( binding_type_name, *instance_definition_modules )
    
    @binding_types[ binding_type_name ] ||= [ ]
    @binding_types[ binding_type_name ].concat( instance_definition_modules )
    
    instance_binding_class( binding_type_name ).module_eval do
      include *instance_definition_modules.reverse
    end
        
  end
  
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
    
    return class_multiple_binding_class( binding_type_name )::InstanceBinding
    
  end

	######################################  Define Classes  ##########################################

  ################################
  #  define_class_binding_class  #
  ################################

  def define_class_binding_class( binding_type_name )

    class_binding_extension_module = self::ClassBinding

    class_binding_class = ::Class.new( ::Magnets::Bindings::ClassBinding ) do

      # We currently don't track class ClassBinding extensions.
      # This could easily be extended by mirroring the InstanceBinding implementation.

      include class_binding_extension_module

    end
    
    # Class name is self::binding_type_name.to_s.to_camel_case
    camel_case_name = binding_type_name.to_s.to_camel_case
    
    const_set( camel_case_name, class_binding_class )

    multiple_class_binding_extension_module = self::ClassBinding::Multiple

    class_multiple_binding_class = ::Class.new( class_binding_class ) do
      
      include ::Magnets::Bindings::Attributes::Multiple
      
      include multiple_class_binding_extension_module
      
    end
    
    class_binding_class.const_set( :Multiple, class_multiple_binding_class )
    
    return class_binding_class
    
  end

  ###################################
  #  define_instance_binding_class  #
  ###################################
  
  def define_instance_binding_class( binding_type_name, *definition_modules )

    instance_binding_extension_module = self::InstanceBinding

    parents = @parents

    instance_binding_class = ::Class.new( ::Magnets::Bindings::InstanceBinding ) do
      
      parents.each do |this_parent|
        # include ClassBinding module for this parent
        include this_parent::InstanceBinding
        # include class binding extension modules for this parent
        instance_binding_extensions = this_parent.instance_binding_extensions( binding_type_name )
        unless instance_binding_extensions.nil? or instance_binding_extensions.empty?
          include *instance_binding_extensions.reverse
        end
      end
      
      include instance_binding_extension_module
      
      unless definition_modules.empty?
        include( *definition_modules.reverse )
      end
          
    end

    # Assumes class binding type has already been defined.
    class_binding_class = class_binding_class( binding_type_name )

    # Class name is self::binding_type_name.to_s.to_camel_case::InstanceBinding
    class_binding_class.const_set( :InstanceBinding, instance_binding_class )
    
    multiple_instance_binding_extension_module = self::ClassBinding::Multiple
    
    instance_multiple_binding_class = ::Class.new( instance_binding_class ) do
      
      include ::Magnets::Bindings::Attributes::Multiple
      
      include multiple_instance_binding_extension_module
      
    end

    # Class name is self::binding_type_name.to_s.to_camel_case::Multiple::InstanceBinding
    class_binding_class::Multiple.const_set( :InstanceBinding, instance_multiple_binding_class )
    
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
    
    method_prefix = ::Magnets::Bindings::AttributeContainer::MethodPrefix.dup
    
    return method_prefix << '_' << binding_type_name.to_s
    
  end
  
  ##################################
  #  multiple_binding_method_name  #
  ##################################
  
  def multiple_binding_method_name( binding_type_name )
    
    method_prefix = ::Magnets::Bindings::AttributeContainer::MethodPrefix.dup
    
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
    
    method_prefix = ::Magnets::Bindings::AttributeContainer::MethodPrefix.dup
    
    # attr_required_[type]
    return method_prefix << '_required_' << binding_type_name.to_s
    
  end
  
  ###########################################
  #  required_multiple_binding_method_name  #
  ###########################################
  
  def required_multiple_binding_method_name( binding_type_name )
    
    method_prefix = ::Magnets::Bindings::AttributeContainer::MethodPrefix.dup
    
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
