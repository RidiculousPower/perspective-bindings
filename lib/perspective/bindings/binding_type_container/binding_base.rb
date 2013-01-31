
###
# BindingBase is a common base class that creates modules to act as base modules for binding types.
#
class ::Perspective::Bindings::BindingTypeContainer::BindingBase < ::Module

  include ::Perspective::Bindings::IncludeExtend

  ################
  #  initialize  #
  ################
  
  def initialize( binding_type_container, & module_define_block )
    
    @binding_type_container = binding_type_container
     
    super( & module_define_block )
    
  end
  
end
