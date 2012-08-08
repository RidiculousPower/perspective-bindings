
begin ; require 'development' ; rescue ::LoadError ; end

require 'perspective/configuration'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

module ::Perspective::Bindings

  extend ::Perspective::Bindings::ParseBindingDeclarationArgs
  	
  include ::Perspective::Bindings::Container
    
end
