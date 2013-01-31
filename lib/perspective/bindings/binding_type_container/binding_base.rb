
###
# BindingBase is a common base class that creates modules to act as base modules for binding types.
#
class ::Perspective::Bindings::BindingTypeContainer::BindingBase < ::Module

  ################
  #  initialize  #
  ################
  
  def initialize( binding_type_container, & module_define_block )
    
    @binding_type_container = binding_type_container
    @child_binding_types = ::Array::Unique.new( self )
     
    super( & module_define_block )
    
  end
  
  ##############
  #  included  #
  ##############
  
  def included( module_instance )

    @child_binding_types.push( module_instance )
    
    super
    
  end

  #################
  #  __include__  #
  #################
  
  alias_method :__include__, :include
  
  #############
  #  include  #
  #############
  
  def include( *modules )
    
    super
    
    _binding_base = self

    @child_binding_types.each do |this_child_binding_type|
      this_child_binding_type.module_eval { include( _binding_base ) }
    end
    
    return self
    
  end

  ################
  #  __extend__  #
  ################

  alias_method :__extend__, :extend
  
  ############
  #  extend  #
  ############

  def extend( *modules )

    super

    @child_binding_types.each do |this_child_binding_type|
      this_child_binding_type.extend( *modules )
    end
    
    return self
    
  end

end
