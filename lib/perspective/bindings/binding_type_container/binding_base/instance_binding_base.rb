
###
#  ClassBindingBase creates modules to function as base modules for including in all instances bindings.
#
class ::Perspective::Bindings::BindingTypeContainer::BindingBase::InstanceBindingBase < 
      ::Perspective::Bindings::BindingTypeContainer::BindingBase
  
  ################
  #  initialize  #
  ################
  
  def initialize( *args )

    super

    include ::Perspective::Bindings::BindingBase::InstanceBinding

  end
  
end
