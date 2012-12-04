
module ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeInterface

  #########
  #  new  #
  #########
  
  def new( binding_type_container, type_name, parent_type_instance = nil )
    
    return ::Class.new( self ) do
      @binding_type_container = binding_type_container
      @type_name = type_name
      create_binding_classes( parent_type_instance )
    end    
    
  end
  
  ############################
  #  create_binding_classes  #
  ############################
  
  def create_binding_classes( parent_type_instance = nil )
    
    binding_type_class = ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeClass
    type = self
    
    binding_class_init_proc = ::Proc.new { @type = type }
    
    @class_binding_class = ::Class.new( binding_type_class, & binding_class_init_proc )
    @nested_class_binding_class = ::Class.new( @class_binding_class, & binding_class_init_proc )
    @instance_binding_class = ::Class.new( binding_type_class, & binding_class_init_proc )
    @nested_instance_binding_class = ::Class.new( @instance_binding_class, & binding_class_init_proc )
    
    const_set( :ClassBinding, @class_binding_class )
    const_set( :NestedClassBinding, @nested_class_binding_class )
    const_set( :InstanceBinding, @instance_binding_class )
    const_set( :NestedInstanceBinding, @nested_instance_binding_class )
    
    register_parent_type( parent_type_instance )
    register_binding_base_parents
    
    return self
    
  end

  ##########################
  #  register_parent_type  #
  ##########################
  
  def register_parent_type( parent_type_instance )
    
    if @parent_type = parent_type_instance
      ::CascadingConfiguration.register_parent( @class_binding_class, 
                                                @parent_type.class_binding_class )
      ::CascadingConfiguration.register_parent( @nested_class_binding_class, 
                                                @parent_type.nested_class_binding_class )
      ::CascadingConfiguration.register_parent( @instance_binding_class, 
                                                @parent_type.instance_binding_class )
      ::CascadingConfiguration.register_parent( @nested_instance_binding_class, 
                                                @parent_type.nested_instance_binding_class )
    end
    
  end

  ###################################
  #  register_binding_base_parents  #
  ###################################

  def register_binding_base_parents
    
    ::CascadingConfiguration.register_parent( @class_binding_class, 
                                              @binding_type_container.class_binding_base )
    ::CascadingConfiguration.register_parent( @nested_class_binding_class, 
                                              @binding_type_container.nested_class_binding_base )
    ::CascadingConfiguration.register_parent( @instance_binding_class, 
                                              @binding_type_container.instance_binding_base )
    ::CascadingConfiguration.register_parent( @nested_instance_binding_class, 
                                              @binding_type_container.nested_instance_binding_base )
    
  end
    
  #################
  #  parent_type  #
  #################

  attr_reader :parent_type
  
  #########################
  #  class_binding_class  #
  #########################

  attr_reader :class_binding_class

  ################################
  #  nested_class_binding_class  #
  ################################

  attr_reader :nested_class_binding_class

  ############################
  #  instance_binding_class  #
  ############################

  attr_reader :instance_binding_class

  ###################################
  #  nested_instance_binding_class  #
  ###################################

  attr_reader :instance_binding_class

end
