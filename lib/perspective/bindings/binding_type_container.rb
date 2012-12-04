
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
#   * NestedClassBinding
#   * InstanceBinding
#   * NestedInstanceBinding
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
#   A BindingTypeContainer holds 4 base container classes:
#
#   * ClassBindingBase
#   * ClassNestedClassBindingBase
#   * InstanceBindingBase
#   * InstanceNestedInstanceBindingBase
#
#   Additionally, a BindingTypeContainer holds each type of binding defined for a given
#   container type. Each BindingType inherits from the appropriate base container class, which is 
#   a subclass of the single common base class. To facilitate ease of translation, the naming
#   schema deployed for actual binding types is a little different (and may seem odd):
#
#   * ClassBinding
#   * NestedClassBinding
#   * ClassBinding::InstanceBinding
#   * NestedClassBinding::NestedInstanceBinding
#
#   This permits translations such as:
#
#   * class_binding.class::NestedClassBinding.new
#   * class_binding.class::InstanceBinding.new
#   * nested_class_binding.class::InstanceBinding.new
#
#   See the definition of #__bindings__ in Perspective::Bindings::Configuration::ObjectAndBindingInstance
#   for the code that utilizes this naming schema.
#
class ::Perspective::Bindings::BindingTypeContainer < ::Module

  include ::Perspective::Bindings::BindingTypeContainer::IncludeExtend
  
  # If we add CascadingConfiguration modules that do not support multiple parents
  # then we will need to rethink the parent registration model to account for
  # separation of single and multiple parent configurations.
  include ::CascadingConfiguration::Hash
  
  MethodPrefix = 'attr'

  ################
  #  initialize  #
  ################
  
  def initialize( type_container_name, subclass_existing_bindings = true, *parent_containers, & module_define_block )
    
    @name = type_container_name
    
    @subclass_existing_bindings = { }
    
    @binding_type_class = self.class::BindingType.new( self, nil )
    
    @class_binding_base           = self.class::BindingBase::ClassBindingBase.new( self )
    @nested_class_binding_base    = self.class::BindingBase::NestedClassBindingBase.new( self )
    @instance_binding_base        = self.class::BindingBase::InstanceBindingBase.new( self )
    @nested_instance_binding_base = self.class::BindingBase::NestedInstanceBindingBase.new( self )
    
    register_parents( subclass_existing_bindings, *parent_containers )
    
    super( & module_define_block )
    
  end

  ########################
  #  class_binding_base  #
  ########################

  attr_reader :class_binding_base

  ###########################
  #  instance_binding_base  #
  ###########################

  attr_reader :instance_binding_base

  ###############################
  #  nested_class_binding_base  #
  ###############################

  attr_reader :nested_class_binding_base

  ##################################
  #  nested_instance_binding_base  #
  ##################################

  attr_reader :nested_instance_binding_base

  #####################
  #  register_parent  #
  #####################

  def register_parent( subclass_existing_bindings, *parent_containers )
    
    # We are either Top Container or Container n.
    # Top Container has CB/NCB/IB/NIB with explicit code as parents.
    # Container n has Container n-1 as parents.
    
    # Register parent for self
    # Register parent for each base module * 4 (CB, NCB, IB, NIB)
    # Register parent for each type * 4
    
    parent_containers.each do |this_parent_container|
      @subclass_existing_bindings[ this_parent_container ] = subclass_existing_bindings
      ::CascadingConfiguration.register_parent( @class_binding_base, 
                                                this_parent_container.class_binding_base )
      ::CascadingConfiguration.register_parent( @nested_class_binding_base, 
                                                this_parent_container.nested_class_binding_base )
      ::CascadingConfiguration.register_parent( @instance_binding_base, 
                                                this_parent_container.instance_binding_base )
      ::CascadingConfiguration.register_parent( @nested_instance_binding_base, 
                                                this_parent_container.nested_instance_binding_base )
      ::CascadingConfiguration.register_parent( self, this_parent_container )
    end
    
    return self
    
  end
  
  ######################
  #  register_parents  #
  ######################
  
  alias_method :register_parents, :register_parent
  
  #################################
  #  subclass_existing_bindings?  #
  #################################
  
  def subclass_existing_bindings?( parent_container )
    
    return @subclass_existing_bindings[ parent_container ]
    
  end

  ###################
  #  binding_types  #
  ###################
  
  attr_hash :binding_types do
    
    #======================#
    #  child_pre_set_hook  #
    #======================#
    
    def child_pre_set_hook( binding_type_name, parent_binding_type_instance, parent_hash )
      
      child_instance = nil
      
      if configuration_instance.subclass_existing_bindings?( parent_hash.configuration_instance )
        child_instance = parent_binding_type_instance.new_binding_type_subclass( self, 
                                                                                 binding_type_name, 
                                                                                 parent_binding_type_instance )
      else
        child_instance = parent_binding_type_instance
      end
      
      return child_instance
      
    end
    
  end

  #####################
  #  binding_aliases  #
  #####################
  
  attr_hash :binding_aliases

  #########################
  #  define_binding_type  #
  #########################
  
  def define_binding_type( binding_type_name, ancestor_type = nil )
    
    # Constant name is provided underscored name converted to camel case
    binding_type_constant_name = binding_type_name.to_s.to_camel_case
    # Method name is lower case version of type name
    binding_method_name = binding_type_name.downcase.to_sym
    # Storage name is provided type name as a symbol
    binding_type_name = binding_type_name.to_sym
    
    # get ancestor instance from ancestor parameter, which can be type name or instance
    parent_type_instance = nil
    case ancestor_type
      # if ancestor_type is already a binding type we use it as the parent type instance
      when ::Perspective::Bindings::BindingTypeContainer::BindingType
        parent_type_instance = ancestor_type
      # if we have a parent type container we can look up a parent type instance
      # * if we have an ancestor type provided explicitly we use it
      # * otherwise we look up the name being defined in parent container
      else
        if @parent_container
          if ancestor_type
            parent_type_instance = @parent_container.binding_types[ ancestor_type.to_sym ]
          else
            parent_type_instance = @parent_container.binding_types[ binding_type_name ]
          end
        end
    end
    
    # create and store new binding type
    new_binding_type = @binding_type_class.new( self, binding_type_name, parent_type_instance )
    const_set( binding_type_constant_name, new_binding_type )
    binding_types[ binding_type_name ] = new_binding_type
    
    # define methods
    define_binding_methods( binding_method_name, binding_type_name )
    
    return new_binding_type
    
  end

  ########################
  #  alias_binding_type  #
  ########################
  
  def alias_binding_type( alias_name, binding_type_name )
    
    alias_name = alias_name.to_sym
    binding_type_name = binding_type_name.to_sym
    
    binding_aliases[ alias_name ] = binding_type_name
    
    const_set( alias_name.to_camel_case, binding_types[ binding_type_name ] )
    
    define_binding_methods( alias_name, binding_type_name )
    
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
    
    binding_type_instance = binding_types[ binding_type_name.to_sym ]
    
    #===============#
    #  attr_[type]  #
    #===============#
    
    define_method( method_name ) do |*args, & block|
      
      new_class_bindings = nil
      
      # type instance can define method, otherwise we use method in self
      if binding_type_instance.respond_to?( :new_class_bindings )
        new_class_bindings = binding_type_instance.new_class_bindings( *args, & block )
      else
        new_class_bindings = new_class_bindings( *args, & block )
      end
      
      new_class_bindings.each do |this_new_class_binding|
        this_new_binding_name = this_new_class_binding.__name__
        __bindings__[ this_new_binding_name ] = this_new_class_binding
        self::Controller::ClassBindingMethods.define_binding( this_new_binding_name )
        self::Controller::InstanceBindingMethods.define_binding( this_new_binding_name )
      end
      
      return new_class_bindings
    
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
    
    define_method( method_name ) do |*args, & configuration_proc|
    
      new_class_bindings = __send__( single_binding_method_name, *args, & configuration_proc )

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
    
    define_method( method_name ) do |*args, & configuration_proc|
    
      new_class_bindings = __send__( single_binding_method_name, *args, & configuration_proc )

      new_class_bindings.each do |this_new_class_binding|
        this_new_class_binding.__required__ = true
      end
    
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
    
    define_method( method_name ) do |*args, & configuration_proc|
    
      new_class_bindings = __send__( multiple_binding_method_name, *args, & configuration_proc )
    
      new_class_bindings.each do |this_new_class_binding|
        this_new_class_binding.__required__ = true
      end
    
      return new_class_bindings
    
    end
    
  end

end