
module ::Magnets::Binding::Types
  
  # We use the module ::Magnets::Binding::Types to store defined types.
  # There is no necessity that this code go here otherwise.
  
  definition_base = ::Magnets::Binding::Definition

  ::Magnets::Binding::Container.define_binding_type( :binding,        definition_base::Binding )
  ::Magnets::Binding::Container.define_binding_type( :class,          definition_base::Class )
  ::Magnets::Binding::Container.define_binding_type( :complex,        definition_base::Complex )
  ::Magnets::Binding::Container.define_binding_type( :file,           definition_base::File )
  ::Magnets::Binding::Container.define_binding_type( :float,          definition_base::Float )
  ::Magnets::Binding::Container.define_binding_type( :integer,        definition_base::Integer )
  ::Magnets::Binding::Container.define_binding_type( :module,         definition_base::Module )
  ::Magnets::Binding::Container.define_binding_type( :number,         definition_base::Number )
  ::Magnets::Binding::Container.define_binding_type( :rational,       definition_base::Rational )
  ::Magnets::Binding::Container.define_binding_type( :regexp,         definition_base::Regexp )
  ::Magnets::Binding::Container.define_binding_type( :text,           definition_base::Text )
  ::Magnets::Binding::Container.define_binding_type( :text_or_number, definition_base::Text,
                                                                      definition_base::Number )
  ::Magnets::Binding::Container.define_binding_type( :true_false,     definition_base::TrueFalse )
  ::Magnets::Binding::Container.define_binding_type( :uri,            definition_base::URI )
  ::Magnets::Binding::Container.define_binding_type( :url,            definition_base::URI )

end
