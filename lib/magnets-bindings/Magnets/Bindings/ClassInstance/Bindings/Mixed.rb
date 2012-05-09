
module ::Magnets::Bindings::ClassInstance::Bindings::Mixed
  
  ################
  #  attr_mixed  #
  ################

  # attr_mixed :name, *types
  # attr_mixed :name, ViewClass, *types
  # 
	def attr_mixed( binding_name, *args, & configuration_proc )

    binding = create_mixed_binding_for_args( binding_name, args, & configuration_proc )
		
		return binding

	end

  #################
  #  attr_mixeds  #
  #################

  # attr_mixeds :name, *types
  # attr_mixeds :name, ViewClass, *types
  # 
	def attr_mixeds( binding_name, *args, & configuration_proc )

    binding = attr_mixed( binding_name, *args, & configuration_proc )
		
	  binding.__multiple_values_permitted__ = true
		
		return binding

	end

  #########################
  #  attr_required_mixed  #
  #########################

  # attr_required_mixed :name, *types
  # attr_required_mixed :name, ViewClass, *types
  # 
	def attr_required_mixed( binding_name, *args, & configuration_proc )
		
		binding = attr_mixed( binding_name, *args, & configuration_proc )

	  binding.__required__ = true
		
		return binding
		
	end

  ##########################
  #  attr_required_mixeds  #
  ##########################

  # attr_required_mixeds :name, *types
  # attr_required_mixeds :name, ViewClass, *types
  # 
	def attr_required_mixeds( binding_name, *args, & configuration_proc )
		
    binding = attr_required_mixed( binding_name, *args, & configuration_proc )
		
	  binding.__multiple_values_permitted__ = true
 		
		return binding
		
	end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ###################################
  #  create_mixed_binding_for_args  #
  ###################################

  # attr_mixed :name, *types
  def create_mixed_binding_for_args( binding_name, args, & configuration_proc )
    
    binding = nil
    
    # check if the first argument is a view, if so remove it from the args array
    view_class = nil
    unless args[ 0 ].is_a?( Symbol ) or args[ 0 ].is_a?( String )
      view_class = args.shift
    end
    
    # create our binding
    binding = __create_binding__( binding_name, view_class, & configuration_proc )
    
    # the rest of the args are permitted types

    args.each do |this_arg|

      case this_arg.to_sym

        when :multiple_values
        
          binding.__multiple_values_permitted__ = true
          
        when :text

          binding.__text_permitted__ = true
        
        when :number
          
          binding.__number_permitted__ = true
        
        when :integer
        
          binding.__integer_permitted__ = true
        
        when :float
      
          binding.__float_permitted__ = true
      
        when :complex
        
          binding.__complex_permitted__ = true
        
        when :rational

          binding.__rational_permitted__ = true
        
        when :regexp
        
          binding.__regexp_permitted__ = true
        
        when :class

          binding.__class_permitted__ = true
        
        when :module

          binding.__module_permitted__ = true
        
        when :true_false

          binding.__true_false_permitted__ = true
        
        when :file

          binding.__file_permitted__ = true
        
        when :view

          binding.__view_permitted__ = true
      
      end
    
    end
    
    return binding
    
  end
  
end
