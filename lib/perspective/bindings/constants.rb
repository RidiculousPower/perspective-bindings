# -*- encoding : utf-8 -*-

module ::Perspective::Bindings

  extend ::Perspective::Bindings::Container::Context

  RouteDelimiter = '::'
  RouteDelimiterLength = RouteDelimiter.length

  ContextPrintPrefix = ':'
  
  ProhibitedNames = { :new   => true }
  
end
