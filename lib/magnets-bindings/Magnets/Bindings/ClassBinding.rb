
class ::Magnets::Bindings::ClassBinding

  include ::Magnets::Bindings::Configuration
  include ::Magnets::Bindings::Configuration::BindingInstance
    
  include ::Magnets::Bindings::ClassBinding::Initialization
  include ::Magnets::Bindings::ClassBinding::Configuration
  include ::Magnets::Bindings::ClassBinding::Bindings
   
  extend ::CascadingConfiguration::Inheritance::IncludeAlsoIncludesInChildren
    
end
