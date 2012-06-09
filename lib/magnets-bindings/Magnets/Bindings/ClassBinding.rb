
class ::Magnets::Bindings::ClassBinding

  include ::Magnets::Bindings::Configuration
  include ::Magnets::Bindings::Configuration::BindingInstance
    
  include ::Magnets::Bindings::ClassBinding::Interface
   
  extend ::CascadingConfiguration::Inheritance::IncludeAlsoIncludesInChildren
    
end
