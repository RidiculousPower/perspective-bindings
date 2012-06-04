
class ::Magnets::Bindings::ClassBinding

  include ::Magnets::Bindings::Configuration
  include ::Magnets::Bindings::Configuration::BindingInstance
    
  include ::Magnets::Bindings::ClassBinding::Initialization
  include ::Magnets::Bindings::ClassBinding::Bindings
  include ::Magnets::Bindings::ClassBinding::Configuration
   
  extend ::CascadingConfiguration::Inheritance::IncludeAlsoIncludesInChildren
    
end
