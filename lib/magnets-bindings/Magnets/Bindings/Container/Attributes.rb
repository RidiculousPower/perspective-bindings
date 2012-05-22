
module ::Magnets::Bindings::Container::Attributes

  ##################################################################################################
  #                                                                                                #
  #  This module assumes that the module it extends has a module self::ClassInstance.              #
  #                                                                                                #
  #  This allows us to use it in multiple places, defining bindings only where they belong:        #
  #                                                                                                #
  #  * Magnets::Bindings::Container                                                                #
  #  * Magnets::Container                                                                          #
  #  * Magnets::ContainerModel                                                                     #
  #  * Magnets::Form                                                                               #
  #                                                                                                #
  #  Magnets::Bindings.define_binding_type( :name, *modules ), defines binding type for all        #
  #  Bindings inheritors, whereas Magnets::Form.define_binding_type( :name, *modules ), defines    #
  #  it only for Form inheritors.                                                                  #
  #                                                                                                #
  ##################################################################################################

  ############################
  #  define_binding_methods  #
  ############################
  
  def define_binding_methods( binding_method_name, binding_type_name = binding_method_name )
        
    define_single_binding_type( binding_method_name, binding_type_name = binding_method_name )
    define_multiple_binding_type( binding_method_name, binding_type_name = binding_method_name )
    define_required_single_binding_type( binding_method_name, binding_type_name = binding_method_name )
    define_required_multiple_binding_type( binding_method_name, binding_type_name = binding_method_name )
    
  end

  ################################
  #  define_single_binding_type  #
  ################################

  def define_single_binding_type( binding_method_name, binding_type_name = binding_method_name )
    
    types = ::Magnets::Bindings::Types
    
    method_name = types.single_binding_method_name( binding_method_name )
    
    class_binding_class = types.class_binding_class( binding_type_name )
    
    self::ClassInstance.module_eval do
      
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
          self::ClassBindingMethods.define_binding( this_binding_name )
          self::InstanceBindingMethods.define_binding( this_binding_name )
        end
        
        return new_bindings
      
      end
      
    end
    
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  def define_multiple_binding_type( binding_method_name, binding_type_name = binding_method_name )
        
    types = ::Magnets::Bindings::Types
    
    method_name = types.multiple_binding_method_name( binding_method_name )
    
    single_binding_method_name = types.single_binding_method_name( binding_method_name )
    
    class_multiple_binding = types.class_binding_class( binding_type_name )::Multiple
    
    self::ClassInstance.module_eval do

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
          self::ClassBindingMethods.define_binding( this_binding_name )
          self::InstanceBindingMethods.define_binding( this_binding_name )
        end
        
        return new_bindings
      
      end
      
    end
    
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  def define_required_single_binding_type( binding_method_name, 
                                           binding_type_name = binding_method_name )
        
    types = ::Magnets::Bindings::Types
        
    method_name = types.required_single_binding_method_name( binding_method_name )
    
    single_binding_method_name = types.single_binding_method_name( binding_method_name )
    
    class_binding_class = types.class_binding_class( binding_type_name )
    
    self::ClassInstance.module_eval do
      
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
    
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  def define_required_multiple_binding_type( binding_method_name, 
                                             binding_type_name = binding_method_name )
    
    types = ::Magnets::Bindings::Types
    
    method_name = types.required_multiple_binding_method_name( binding_method_name )
    
    multiple_binding_method_name = types.multiple_binding_method_name( binding_method_name )
    
    class_binding_class = types.class_binding_class( binding_type_name )
    
    self::ClassInstance.module_eval do
      
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

end
