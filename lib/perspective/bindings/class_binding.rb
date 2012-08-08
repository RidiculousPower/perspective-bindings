
class ::Perspective::Bindings::ClassBinding

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::Configuration::BindingInstance
    
  include ::Perspective::Bindings::ClassBinding::ObjectInstance
  extend ::Perspective::Bindings::ClassBinding::ClassInstance
    
end
