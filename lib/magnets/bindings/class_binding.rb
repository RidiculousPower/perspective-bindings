
class ::Magnets::Bindings::ClassBinding

  include ::Magnets::Bindings::Configuration
  include ::Magnets::Bindings::Configuration::BindingInstance
    
  include ::Magnets::Bindings::ClassBinding::ObjectInstance
  extend ::Magnets::Bindings::ClassBinding::ClassInstance
    
end
