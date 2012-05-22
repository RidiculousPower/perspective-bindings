
class ::Magnets::Bindings::InstanceBinding
  
  include ::Magnets::Bindings::Configuration
  include ::Magnets::Bindings::Configuration::BindingInstance
  
  include ::Magnets::Bindings::InstanceBinding::Initialization
  include ::Magnets::Bindings::InstanceBinding::Configuration
  include ::Magnets::Bindings::InstanceBinding::Rendering
  include ::Magnets::Bindings::InstanceBinding::Validation
  include ::Magnets::Bindings::InstanceBinding::Value

  extend ::CascadingConfiguration::Inheritance::IncludeAlsoIncludesInChildren
  
end
