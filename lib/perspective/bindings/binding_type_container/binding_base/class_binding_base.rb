
###
#  ClassBindingBase creates modules to function as base modules for including in all class bindings.
#
class ::Perspective::Bindings::BindingTypeContainer::BindingBase::ClassBindingBase < 
      ::Perspective::Bindings::BindingTypeContainer::BindingBase
  
  ################
  #  initialize  #
  ################
  
  def initialize( *args )

    super

    include ::Perspective::Bindings::BindingBase::ClassBinding

  end
  
end
