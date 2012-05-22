
# declare binding types here
# we will declare binding methods separately (on the container)

module ::Magnets::Bindings::Types
  
  # We use the module ::Magnets::Bindings::Types to store defined types.
  # There is no necessity that this code go here otherwise.

  extend ::Magnets::Bindings::Attributes
  
  base = ::Magnets::Bindings::Attributes

  ::Magnets::Bindings::Types.define_binding_type( :binding,        base::Binding )
  ::Magnets::Bindings::Types.define_binding_type( :class,          base::Class )
  ::Magnets::Bindings::Types.define_binding_type( :complex,        base::Complex )
  ::Magnets::Bindings::Types.define_binding_type( :file,           base::File )
  ::Magnets::Bindings::Types.define_binding_type( :float,          base::Float )
  ::Magnets::Bindings::Types.define_binding_type( :integer,        base::Integer )
  ::Magnets::Bindings::Types.define_binding_type( :module,         base::Module )
  ::Magnets::Bindings::Types.define_binding_type( :number,         base::Number )
  ::Magnets::Bindings::Types.define_binding_type( :rational,       base::Rational )
  ::Magnets::Bindings::Types.define_binding_type( :regexp,         base::Regexp )
  ::Magnets::Bindings::Types.define_binding_type( :text,           base::Text )
  ::Magnets::Bindings::Types.define_binding_type( :text_or_number, base::Text,
                                                                   base::Number )
  ::Magnets::Bindings::Types.define_binding_type( :true_false,     base::TrueFalse )
  ::Magnets::Bindings::Types.define_binding_type( :uri,            base::URI )
  ::Magnets::Bindings::Types.define_binding_type( :url,            base::URI )

  ::Magnets::Bindings::Container.define_binding_methods( :binding )
  ::Magnets::Bindings::Container.define_binding_methods( :class )
  ::Magnets::Bindings::Container.define_binding_methods( :complex )
  ::Magnets::Bindings::Container.define_binding_methods( :file )
  ::Magnets::Bindings::Container.define_binding_methods( :float )
  ::Magnets::Bindings::Container.define_binding_methods( :integer )
  ::Magnets::Bindings::Container.define_binding_methods( :module )
  ::Magnets::Bindings::Container.define_binding_methods( :number )
  ::Magnets::Bindings::Container.define_binding_methods( :rational )
  ::Magnets::Bindings::Container.define_binding_methods( :regexp )
  ::Magnets::Bindings::Container.define_binding_methods( :text )
  ::Magnets::Bindings::Container.define_binding_methods( :text_or_number )
  ::Magnets::Bindings::Container.define_binding_methods( :true_false )
  ::Magnets::Bindings::Container.define_binding_methods( :uri )

end
