# -*- encoding : utf-8 -*-

###
# Create our PropertyBindings BindingTypeContainer, which will automatically be stored at
#   at ::Perspective::BindingTypes::PropertyBindings.
#
#   Property bindings are the basic binding type, providing value-oriented binding functionality.
#
module ::Perspective::BindingTypes::PropertyBindings

  ###########################
  #  attr_binding_property  #
  ###########################

  define_binding_type( :binding_property )

  #########################
  #  attr_class_property  #
  #########################

  define_binding_type( :class_property )

  ###########################
  #  attr_complex_property  #
  ###########################

  define_binding_type( :complex_property )

  ########################
  #  attr_file_property  #
  ########################

  define_binding_type( :file_property )

  #########################
  #  attr_float_property  #
  #########################

  define_binding_type( :float_property )

  ###########################
  #  attr_integer_property  #
  ###########################

  define_binding_type( :integer_property )

  ##########################
  #  attr_module_property  #
  ##########################

  define_binding_type( :module_property )

  ##########################
  #  attr_number_property  #
  ##########################
  
  define_binding_type( :number_property )
  
  ############################
  #  attr_rational_property  #
  ############################
  
  define_binding_type( :rational_property )
  
  ##########################
  #  attr_regexp_property  #
  ##########################
  
  define_binding_type( :regexp_property )
  
  ########################
  #  attr_text_property  #
  ########################
  
  define_binding_type( :text_property )
  
  ##################################
  #  attr_text_or_number_property  #
  ##################################
  
  define_binding_type( :text_or_number_property )
  
  ##############################
  #  attr_true_false_property  #
  ##############################
  
  define_binding_type( :true_false_property )
  
  #######################
  #  attr_uri_property  #
  #######################
  
  define_binding_type( :URI_property )

  #######################
  #  attr_nil_property  #
  #######################
  
  define_binding_type( :nil_property )

end
