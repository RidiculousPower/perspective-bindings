
###
# A BindingType groups the actual classes used to create a binding of the given type.
#
#   A BindingType holds modules for each binding type so that they can be included
#   in inheriting modules of the same type. 
#
#   A BindingType also holds classes for each binding type, which are used to create
#   the actual bindings that will be used.
#
class ::Perspective::Bindings::BindingTypeContainer::BindingType
  
  extend ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeInterface
  
end
