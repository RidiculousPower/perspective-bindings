
class ::Perspective::Bindings::BindingTypeContainer < ::Module
  
  extend ::Forwardable

  MethodPrefix = 'attr'

  ################
  #  initialize  #
  ################
  
  def initialize( type_container_name, parent_container = nil, subclass_existing_bindings = true, & module_block )
    
    @type_container_name = type_container_name
    
    parent_type_controller = parent_container ? parent_container.types : nil
    @types = self.class::TypesController.new( parent_type_controller, subclass_existing_bindings )

    const_set( :ClassBinding, @types.class_binding_base )
    const_set( :InstanceBinding, @types.instance_binding_base )

    include parent_container if @parent_container = parent_container
    
    super( & module_block )

  end

  ######################
  #  parent_container  #
  ######################
  
  attr_reader :parent_container

  ###########
  #  types  #
  ###########
  
  attr_reader :types
  
  #########################
  #  type_container_name  #
  #########################
  
  attr_reader :type_container_name

  ###################
  #  binding_types  #
  ###################

  def_delegator :@types, :binding_types

  #####################
  #  binding_aliases  #
  #####################

  def_delegator :@types, :binding_aliases

  #########################
  #  define_binding_type  #
  #########################
  
  def define_binding_type( binding_type_name, ancestor_type = nil )
    
    new_binding_type = @types.define_binding_type( binding_type_name, ancestor_type )

    binding_type_name = binding_type_name.to_s
    binding_type_constant_name = binding_type_name.to_camel_case
    binding_method_name = binding_type_name.downcase.to_sym
    remove_const( binding_type_constant_name ) if const_defined?( binding_type_constant_name, false )
    const_set( binding_type_constant_name, new_binding_type )
    
    define_binding_methods( binding_method_name, binding_type_name )
    
    return new_binding_type
    
  end
  
  ########################
  #  alias_binding_type  #
  ########################

  def alias_binding_type( alias_name, binding_type_name )
    
    alias_name = alias_name.to_sym
    binding_type_name = binding_type_name.to_sym
    
    @types.alias_binding_type( alias_name, binding_type_name )
    
    aliased_type_instance = binding_types[ binding_type_name ]
    binding_alias_constant_name = alias_name.to_s.to_camel_case
    const_set( binding_alias_constant_name, aliased_type_instance )
    
    define_binding_methods( alias_name, binding_type_name )
    
    return aliased_type_instance
    
  end
  
  ########################
  #  new_class_bindings  #
  ########################
  
  ###
  # Create a new class binding for each binding name, each having the same configuration block. 
  #
  # 
  #
  def new_class_bindings( binding_type, bound_to_container, *binding_names, & configuration_proc )
    
    return binding_names.collect do |this_binding_name|
      binding_type.class_binding_class.new( bound_to_container, this_binding_name, & configuration_proc )
    end
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

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
    
    return ::Perspective::Bindings::BindingTypeContainer::MethodPrefix + '_' << binding_type_name.to_s
    
  end
  
  ##################################
  #  multiple_binding_method_name  #
  ##################################
  
  def multiple_binding_method_name( binding_type_name )
        
    # attr_[type]s or attr_[types]es

    method_name = ::Perspective::Bindings::BindingTypeContainer::MethodPrefix + '_' << binding_type_name.to_s
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

    return ::Perspective::Bindings::BindingTypeContainer::MethodPrefix + '_required_' << binding_type_name.to_s
    
  end
  
  ###########################################
  #  required_multiple_binding_method_name  #
  ###########################################
  
  def required_multiple_binding_method_name( binding_type_name )
    
    # attr_required_[type]s or attr_required_[types]es

    method_name = ::Perspective::Bindings::BindingTypeContainer::MethodPrefix + '_required_' << binding_type_name.to_s
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

    binding_type_instance = @types.binding_types[ binding_type_name.to_sym ]
    type_container = self

    #===============#
    #  attr_[type]  #
    #===============#
    
    define_method( method_name ) do |*args, & block|
      
      new_class_bindings = type_container.new_class_bindings( binding_type_instance, self, *args, & block )

      return new_class_bindings.each do |this_new_class_binding|
        this_new_binding_name = this_new_class_binding.__name__
        __bindings__[ this_new_binding_name ] = this_new_class_binding
        self::Controller::ClassBindingMethods.define_binding( this_new_binding_name )
        self::Controller::InstanceBindingMethods.define_binding( this_new_binding_name )
      end
    
    end
    
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  def define_multiple_binding_type( binding_method_name, binding_type_name = binding_method_name )
        
    method_name = multiple_binding_method_name( binding_method_name )
    single_binding_method_name = single_binding_method_name( binding_method_name )
        
    #================#
    #  attr_[type]s  #
    #================#
    
    define_method( method_name ) do |*args, & block|
    
      new_class_bindings = __send__( single_binding_method_name, *args, & block )

      new_class_bindings.each do |this_new_class_binding|
        this_new_class_binding.__permits_multiple__ = true
        __bindings__[ this_new_class_binding.__name__ ] = this_new_class_binding
      end
      
      return new_class_bindings
    
    end
    
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  def define_required_single_binding_type( binding_method_name, binding_type_name = binding_method_name )
        
    method_name = required_single_binding_method_name( binding_method_name )
    single_binding_method_name = single_binding_method_name( binding_method_name )
        
    #========================#
    #  attr_required_[type]  #
    #========================#
    
    define_method( method_name ) do |*args, & block|
    
      new_class_bindings = __send__( single_binding_method_name, *args, & block )
      new_class_bindings.each { |this_new_class_binding| this_new_class_binding.__required__ = true }
    
      return new_class_bindings
    
    end
    
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  def define_required_multiple_binding_type( binding_method_name, binding_type_name = binding_method_name )
    
    method_name = required_multiple_binding_method_name( binding_method_name )
    multiple_binding_method_name = multiple_binding_method_name( binding_method_name )
    
    #=========================#
    #  attr_required_[type]s  #
    #=========================#
    
    define_method( method_name ) do |*args, & block|
    
      new_class_bindings = __send__( multiple_binding_method_name, *args, & block )
      new_class_bindings.each { |this_new_class_binding| this_new_class_binding.__required__ = true }
    
      return new_class_bindings
    
    end
    
  end

end
