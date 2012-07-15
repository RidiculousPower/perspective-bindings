
begin ; require 'development' ; rescue ::LoadError ; end

require 'magnets/configuration'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

module ::Magnets::Bindings

  extend ::Magnets::Bindings::ParseBindingDeclarationArgs
  	
  include ::Magnets::Bindings::Container
    
end
