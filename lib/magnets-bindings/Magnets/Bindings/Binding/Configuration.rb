
module ::Magnets::Bindings::Binding::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique
  
  ###############
  #  configure  #
  ###############

  def configure( & configuration_proc )
        
    __configuration_procs__.push( configuration_proc )
    
  end

  # We declare as cascading configurations so that bindings can inherit configurations
  # in parallel with class/module inheritance tree (to which they are bound).
  # Inheritance is accomplished using CascadingConfiguration::Variable functionality;
  # for details, see #initialize.
  
  ####################################
  #  __name__                        #
  #  __view_class__                  #
  #  __corresponding_view_binding__  #
  ####################################
  
  # Identity
  # --------
  # 
  attr_configuration        :__name__, :__view_class__, :__corresponding_view_binding__

  #####################
  #  __view_class__=  #
  #####################

  def __view_class__=( view_class )
    
    super
    
    if __corresponding_view_binding__
      
      __corresponding_view_binding__.__view_class__ = view_class
      
    end
    
  end

  ##################################################################
  #  required?,                    __required__=                   #
  #  multiple_values_permitted?,   __multiple_values_permitted__=  #
  #  object_permitted?,            __object_permitted__=           #
  #      view_permitted?,          __view_permitted__=             #
  #      text_permitted?,          __text_permitted__=             #
  #      number_permitted?,        __number_permitted__=           #
  #          integer_permitted?,   __integer_permitted__=          #
  #          float_permitted?,     __float_permitted__=            #
  #          complex_permitted?,   __complex_permitted__=          #
  #          rational_permitted?,  __rational_permitted__=         #
  #      module_permitted?,        __module_permitted__=           #
  #      class_permitted?,         __class_permitted__=            #
  #      true_false_permitted?,    __true_false_permitted__=       #
  #      regexp_permitted?,        __regexp_permitted__=           #
  #      file_permitted?,          __file_permitted__=             #
  #      input_permitted?,          __input_permitted__=           #
  ##################################################################

  # Constraints
  # -----------
  #
  # Indented listings are sub-constraints from general constraint they are indented below
  # 
  attr_configuration        :required?                    => :__required__=, 
                            :multiple_values_permitted?   => :__multiple_values_permitted__=, 
                            :object_permitted?            => :__object_permitted__=,
                                :view_permitted?          => :__view_permitted__=, 
                                :text_permitted?          => :__text_permitted__=, 
                                :number_permitted?        => :__number_permitted__=, 
                                    :integer_permitted?   => :__integer_permitted__=, 
                                    :float_permitted?     => :__float_permitted__=,
                                    :complex_permitted?   => :__complex_permitted__=,
                                    :rational_permitted?  => :__rational_permitted__=, 
                                :module_permitted?        => :__module_permitted__=, 
                                :class_permitted?         => :__class_permitted__=, 
                                :true_false_permitted?    => :__true_false_permitted__=,
                                :regexp_permitted?        => :__regexp_permitted__=, 
                                :file_permitted?          => :__file_permitted__=,
                                :input_permitted?         => :__input_permitted__=
  
  ###############
  #  optional?  #
  ###############
  
  def optional?
  
    return ! required?
  
  end
  
  #############################
  #  __configuration_procs__  #
  #############################
                              
  # Configuration
  # -------------
  #
  attr_configuration_unique_array  :__configuration_procs__

  #############################
  #  __route__                #
  #  __bound_module__           #
  #  __sub_bindings__         #
  #  __shared_sub_bindings__  #
  #############################
  
  # Instance-Specific Elements
  # --------------------------
  #
  attr_reader                      :__route__, :__route_string__, 
                                   :__bound_module__, 
                                   :__sub_bindings__, :__shared_sub_bindings__

end
