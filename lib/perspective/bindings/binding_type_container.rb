
###
# Bindings exist to relate containers to one another.
#
#   Class bindings 1. permit slots to be defined where particular types of values are
#   expected to be provided 2. permit configuration blocks to be provided for when
#   corresponding instances are initialized. 3. permit one class to be nested in another, 
#   with the container class specifying configuration details for the nested container 
#   unique to the containing class.
#
#   Instance bindings correspond to class bindings, 1. relating values to views 
#   2. ensuring that the container is prepared to accept values without a view
#   present where the value would be embedded. 3. ensuring that the structure of
#   nested instances corresponds to the description of nested classes.
#
#   Accordingly, each class binding has a corresponding instance binding. Further,
#   class and instance bindings have "nested" types, used to distinguish whether
#   a binding is attached to a container or another binding. We thus have:
#
#   * ClassBinding
#   * InstanceBinding
#
#   We want to be able to support multiple types of containers. This means we want a
#   given container to be able to inherit bindings from another container as well as
#   extending those bindings and adding its own additional bindings. But we don't want
#   changes in an inheriting container to affect the bindings in the container it
#   inherited from. This means that each container type needs its own base binding
#   types, but also that binding type ought to inherit from the parent container's
#   binding type. The result is that we expect multiple inheritance, which clearly
#   is not possible by way of classes. We get around this by collecting a stack of
#   modules used to extend each binding type, ensuring the module stack cascades
#   appropriately. 
#
#   This is accomplished by defining each binding container context as a BindingTypeContainer.
#   A BindingTypeContainer holds 4 base container modules:
#
#   * ClassBindingBase
#   * InstanceBindingBase
#
#   Additionally, a BindingTypeContainer holds each type of binding defined for a given
#   container type. To facilitate ease of translation, the naming schema deployed for 
#   actual binding types is a little different (and may seem odd):
#
#   * ClassBinding
#   * ClassBinding::InstanceBinding
#
#   This permits translations such as:
#
#   * class_binding.class::InstanceBinding.new
#   * nested_class_binding.class::InstanceBinding.new
#
#   See the definition of #__bindings__ in Perspective::Bindings::Configuration::ObjectAndBindingInstance
#   for the code that utilizes this naming schema.
#
class ::Perspective::Bindings::BindingTypeContainer < ::Module
  
  extend ::Forwardable

  MethodPrefix = 'attr'

  ################
  #  initialize  #
  ################
  
  def initialize( type_container_name, parent_container = nil, subclass_existing_bindings = true, & module_block )
    
    @type_container_name = type_container_name
    
    @types = self.class::TypesController.new( parent_container ? parent_container.types : nil, subclass_existing_bindings )

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
    
    remove_const( binding_type_constant_name ) if const_defined?( binding_type_constant_name )
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
    
    #===============#
    #  attr_[type]  #
    #===============#
    
    define_method( method_name ) do |*args, & block|
      
      binding_type_instance = binding_types[ binding_type_name.to_sym ]
      type_container = binding_type_instance.type_container

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
