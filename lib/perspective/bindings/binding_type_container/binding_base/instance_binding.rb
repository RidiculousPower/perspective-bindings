
###
#  ClassBinding creates modules to function as base modules for including in all instances bindings.
#
class ::Perspective::Bindings::BindingTypeContainer::BindingBase::InstanceBinding < 
      ::Perspective::Bindings::BindingTypeContainer::BindingBase
  
  ################
  #  initialize  #
  ################
  
  def initialize( *args )

    super

    include ::Perspective::Bindings::BindingBase::InstanceBinding

  end
  
end
