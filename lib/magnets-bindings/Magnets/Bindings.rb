
module ::Magnets::Bindings

  extend ::Magnets::Bindings::ParseBindingDeclarationArgs
  
  include ::Magnets::Bindings::Container
  
  ProhibitedNames = {
    :new => true
  }
  
  RouteDelimiter = '-'

end
