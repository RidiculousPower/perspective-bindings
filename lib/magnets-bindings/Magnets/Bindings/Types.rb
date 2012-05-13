
binding_definition_base = ::Magnets::Bindings::Binding::Definition

::Magnets::Bindings.define_binding_type( :binding,        binding_definition_base::Binding )
::Magnets::Bindings.define_binding_type( :class,          binding_definition_base::Class )
::Magnets::Bindings.define_binding_type( :complex,        binding_definition_base::Complex )
::Magnets::Bindings.define_binding_type( :file,           binding_definition_base::File )
::Magnets::Bindings.define_binding_type( :float,          binding_definition_base::Float )
::Magnets::Bindings.define_binding_type( :integer,        binding_definition_base::Integer )
::Magnets::Bindings.define_binding_type( :module,         binding_definition_base::Module )
::Magnets::Bindings.define_binding_type( :number,         binding_definition_base::Number )
::Magnets::Bindings.define_binding_type( :rational,       binding_definition_base::Rational )
::Magnets::Bindings.define_binding_type( :regexp,         binding_definition_base::Regexp )
::Magnets::Bindings.define_binding_type( :text,           binding_definition_base::Text )
::Magnets::Bindings.define_binding_type( :text_or_number, binding_definition_base::Text,
                                                          binding_definition_base::Number )
::Magnets::Bindings.define_binding_type( :true_false,     binding_definition_base::TrueFalse )
::Magnets::Bindings.define_binding_type( :uri,            binding_definition_base::URI )
::Magnets::Bindings.define_binding_type( :url,            binding_definition_base::URI )
