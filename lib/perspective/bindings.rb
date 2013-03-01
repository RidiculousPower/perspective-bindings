# -*- encoding : utf-8 -*-

require 'perspective/configuration'

# namespaces that have to be declared ahead of time for proper load order
require_relative './namespaces'

# source file requires
require_relative './requires.rb'

###
# Bindings exist to relate containers to one another.
#
#   Class bindings 1. permit slots to be defined where particular types of values are
#   expected to be provided 2. permit configuration blocks to be provided for when
#   corresponding instances are initialized. 3. permit one class to be nested in another, 
#   with the container class specifying configuration details for the nested container 
#   unique to the containing class.
#
#   Instance bindings correspond to class bindings, 1. relating values to views 
#   2. ensuring that the container is prepared to accept values without a view
#   present where the value would be embedded. 3. ensuring that the structure of
#   nested instances corresponds to the description of nested classes.
#
#   We want to be able to support multiple types of containers. This means we want a
#   given container to be able to inherit bindings from another container as well as
#   extending those bindings and adding its own additional bindings. But we don't want
#   changes in an inheriting container to affect the bindings in the container it
#   inherited from. This means that each container type needs its own base binding
#   types, but also that binding type ought to inherit from the parent container's
#   binding type. The result is that we expect multiple inheritance, which clearly
#   is not possible by way of classes. We get around this by collecting a stack of
#   modules used to extend each binding type, ensuring the module stack cascades
#   appropriately. 
#
module ::Perspective::Bindings

  include ::Perspective::Bindings::Container
  
  ########################
  #  self.spec_location  #
  ########################
  
  ###
  # Returns location of Perspective::Bindings specs and spec support files.
  #
  # @return [String] Path to location of spec files.
  #
  def self.spec_location
    
    return ::File.expand_path( ::File.dirname( __FILE__ ) << '/../../spec' )    

  end
  
end
