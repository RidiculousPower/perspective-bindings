
module ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeInterface

  #########
  #  new  #
  #########
  
  ###
  # We use a class so that singleton inheritance cascades. We do not want instances of
  #   the singleton, so we override #new to give us a subclass.
  #
  def new( binding_type_container, type_name, parent_type_instance = nil )
    
    return ::Class.new( self ) do

      @binding_type_container = binding_type_container
      @type_name = type_name

      parent_class_binding_module           = nil
      parent_nested_class_binding_module    = nil
      parent_instance_binding_module        = nil
      parent_nested_instance_binding_module = nil
      
      if @parent_type = parent_type_instance
        
        # class binding
        @class_binding_module =           ::Perspective::Bindings::BindingTypeContainer::BindingType::
                                            BindingTypeModule.new( self, 
                                                                   binding_type_container.class_binding_base,
                                                                   parent_type_instance.class_binding_module ) 
        # nested class binding
        @nested_class_binding_module =    ::Perspective::Bindings::BindingTypeContainer::BindingType::
                                            BindingTypeModule.new( self,
                                                                   binding_type_container.nested_class_binding_base,
                                                                   @class_binding_module,
                                                                   parent_type_instance.nested_class_binding_module )
        # instance binding
        @instance_binding_module =        ::Perspective::Bindings::BindingTypeContainer::BindingType::
                                            BindingTypeModule.new( self,
                                                                   binding_type_container.instance_binding_base,
                                                                   parent_type_instance.instance_binding_module )
        # nested instance binding
        @nested_instance_binding_module = ::Perspective::Bindings::BindingTypeContainer::BindingType::
                                            BindingTypeModule.new( self,
                                                                   @instance_binding_module,
                                                                   binding_type_container.nested_instance_binding_base,
                                                                   parent_type_instance.nested_instance_binding_module )
      else
        # class binding
        @class_binding_module =           ::Perspective::Bindings::BindingTypeContainer::BindingType::
                                            BindingTypeModule.new( self, 
                                                                   @binding_type_container.class_binding_base ) 
        # nested class binding
        @nested_class_binding_module =    ::Perspective::Bindings::BindingTypeContainer::BindingType::
                                            BindingTypeModule.new( self,
                                                                   binding_type_container.nested_class_binding_base,
                                                                   @class_binding_module )
        # instance binding
        @instance_binding_module =        ::Perspective::Bindings::BindingTypeContainer::BindingType::
                                            BindingTypeModule.new( self,
                                                                   binding_type_container.instance_binding_base )
        # nested instance binding
        @nested_instance_binding_module = ::Perspective::Bindings::BindingTypeContainer::BindingType::
                                            BindingTypeModule.new( self,
                                                                   @instance_binding_module,
                                                                   binding_type_container.nested_instance_binding_base )
      end
      
      const_set( :ClassBinding,          @class_binding_module )
      const_set( :NestedClassBinding,    @nested_class_binding_module )
      const_set( :InstanceBinding,       @instance_binding_module )
      const_set( :NestedInstanceBinding, @nested_instance_binding_module )

    end
    
  end

  ###############
  #  type_name  #
  ###############
  
  ###
  # Name of binding type.
  #
  # @!attribute [r] type_name
  #
  # @return [Symbol,String] Name of binding type.
  #
  attr_reader :type_name

  ############################
  #  binding_type_container  #
  ############################
  
  attr_reader :binding_type_container

  #################
  #  parent_type  #
  #################

  attr_reader :parent_type

  ##########################
  #  class_binding_module  #
  ##########################

  attr_reader :class_binding_module

  ##################################
  #  nested_module_binding_module  #
  ##################################

  attr_reader :nested_class_binding_module

  #############################
  #  instance_binding_module  #
  #############################

  attr_reader :instance_binding_module

  ####################################
  #  nested_instance_binding_module  #
  ####################################

  attr_reader :nested_instance_binding_module
  
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

  attr_reader :nested_instance_binding_class
    
end
