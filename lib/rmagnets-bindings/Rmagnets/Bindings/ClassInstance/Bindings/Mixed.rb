
module ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed
  
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
		
	  binding.multiple_values_permitted = true
		
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

	  binding.required = true
		
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
		
	  binding.multiple_values_permitted = true
 		
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
    binding = create_binding( binding_name, view_class, & configuration_proc )
    
    # the rest of the args are permitted types

    args.each do |this_arg|

      case this_arg.to_sym

        when :multiple_values
        
          binding.multiple_values_permitted = true
          
        when :text

          binding.text_permitted = true
        
        when :number
          
          binding.number_permitted = true
        
        when :integer
        
          binding.integer_permitted = true
        
        when :float
      
          binding.float_permitted = true
      
        when :complex
        
          binding.complex_permitted = true
        
        when :rational

          binding.rational_permitted = true
        
        when :regexp
        
          binding.regexp_permitted = true
        
        when :class

          binding.class_permitted = true
        
        when :module

          binding.module_permitted = true
        
        when :true_false

          binding.true_false_permitted = true
        
        when :file

          binding.file_permitted = true
        
        when :view

          binding.view_permitted = true
      
      end
    
    end
    
    return binding
    
  end
  
end
