
module ::Perspective::Bindings::Container::Nested::ClassInstance
  
  #########################
  #  initialize_bindings  #
  #########################
  
  def initialize_bindings( instance )

    # do nothing - non-nested class initiates cascading initialization of bindings
    
  end

  ######################
  #  non_nested_class  #
  ######################
  
  attr_accessor :non_nested_class
  
end
