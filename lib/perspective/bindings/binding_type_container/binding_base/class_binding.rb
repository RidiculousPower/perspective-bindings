# -*- encoding : utf-8 -*-

###
#  ClassBinding creates modules to function as base modules for including in all class bindings.
#
class ::Perspective::Bindings::BindingTypeContainer::BindingBase::ClassBinding < 
      ::Perspective::Bindings::BindingTypeContainer::BindingBase
  
  ################
  #  initialize  #
  ################
  
  def initialize( *args )

    super

    include ::Perspective::Bindings::BindingBase::ClassBinding

  end
  
end
