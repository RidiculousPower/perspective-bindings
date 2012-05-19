
class ::Magnets::Binding::InstanceBinding
  
  include ::Magnets::Binding::Configuration
  include ::Magnets::Binding::Configuration::BindingInstance
  
  include ::Magnets::Binding::InstanceBinding::Initialization
  include ::Magnets::Binding::InstanceBinding::Configuration
  include ::Magnets::Binding::InstanceBinding::Rendering
  include ::Magnets::Binding::InstanceBinding::Validation
  include ::Magnets::Binding::InstanceBinding::Value
  
end
