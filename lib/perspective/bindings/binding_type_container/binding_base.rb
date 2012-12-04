
class ::Perspective::Bindings::BindingTypeContainer::BindingBase < ::Module

  ################
  #  initialize  #
  ################
  
  def initialize( binding_type_container, & module_define_block )
    
    @binding_type_container = binding_type_container
    
    super( & module_define_block )
    
  end
  
end
