
###
# Create our ViewBindings BindingTypeContainer, which will automatically be stored at
#   at ::Perspective::Bindings::BindingTypes::ViewBindings.
#
#   View bindings add view-related features to bindings.
#
::Perspective::Bindings::BindingTypes.define_container_type( :view_bindings, :property_bindings, false )

###
# For convenience we create a Constant ::Perspective::View::ViewBindings pointing to our 
#   BindingTypeContainer at ::Perspective::Bindings::BindingTypes::ViewBindings.
#
::Perspective::View.const_set( :ViewBindings, ::Perspective::Bindings::BindingTypes::ViewBindings )

class ::Perspective::View::ViewBindings

  extend ::Perspective::View::ViewBindingTypeContainerInterface
  
  ##################
  #  attr_binding  #
  ##################

  define_binding_type( :binding, :binding_property )

  ################
  #  attr_class  #
  ################

  define_binding_type( :class, :class_property )

  ##################
  #  attr_complex  #
  ##################

  define_binding_type( :complex, :complex_property )

  ###############
  #  attr_file  #
  ###############

  define_binding_type( :file, :file_property )

  ################
  #  attr_float  #
  ################

  define_binding_type( :float, :float_property )

  ##################
  #  attr_integer  #
  ##################

  define_binding_type( :integer, :integer_property )

  #################
  #  attr_module  #
  #################

  define_binding_type( :module, :module_property )

  #################
  #  attr_number  #
  #################

  define_binding_type( :number, :number_property )

  ###################
  #  attr_rational  #
  ###################

  define_binding_type( :rational, :rational_property )

  #################
  #  attr_regexp  #
  #################
  
  define_binding_type( :regexp, :regexp_property )
  
  ###############
  #  attr_text  #
  ###############
  
  define_binding_type( :text, :text_property )
  
  #########################
  #  attr_text_or_number  #
  #########################
  
  define_binding_type( :text_or_number, :text_or_number_property )
  
  #####################
  #  attr_true_false  #
  #####################
  
  define_binding_type( :true_false, :true_false_property )
  
  ##############
  #  attr_uri  #
  ##############
  
  define_binding_type( :URI, :URI_property )

end
