# -*- encoding : utf-8 -*-

module ::Perspective::Bindings

  extend ::Perspective::Bindings::Container::Context

  RouteDelimiter = '::'

  ContextPrintPrefix = ':'
  
  ProhibitedNames = { :new   => true,
                      :value => true }
  
end
