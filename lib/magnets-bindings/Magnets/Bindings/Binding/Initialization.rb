
module ::Magnets::Bindings::Binding::Initialization

  ################
  #  initialize  #
  ################

  def initialize( bound_module, 
                  binding_name, 
                  view_class = nil, 
                  ancestor_binding = nil,
                  base_route = nil, 
                  & configuration_proc )
    
    __validate_initialization__( binding_name, view_class )
    
    self.__name__ = binding_name
    
    @__bound_module__ = bound_module

    __initialize_for_route__( base_route, binding_name )
   
    __initialize_for_ancestor__( ancestor_binding )
    
    __initialize_sub_bindings_for_view_class__( view_class )
        
    if block_given?
      configure( & configuration_proc )
    end
        
  end

  #################################
  #  __validate_initialization__  #
  #################################

  def __validate_initialization__( binding_name, view_class )
    
    if ::Magnets::Bindings::ProhibitedNames.has_key?( binding_name.to_sym )
      raise ::ArgumentError, 'Cannot declare :' + binding_name.to_s + ' as a binding - prohibited' +
                             ' to prevent errors that are very difficult to debug.'
    end
	  
	  if view_class

      unless view_class.method_defined?( :to_html_node )     or 
             view_class.method_defined?( :to_html_fragment )

        raise ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError,
                'View class specified (' + view_class.to_s + ') does not respond to either ' +
                ':to_html_node or :to_html_fragment.'
      end
      
    end
    
  end

  ##############################
  #  __initialize_for_route__  #
  ##############################
  
  def __initialize_for_route__( base_route, binding_name )
    
    if @__route__ = base_route
      @__route_string__ = base_route.join( ::Magnets::Bindings::RouteDelimiter )
      @__route_string__ << ::Magnets::Bindings::RouteDelimiter
    else
      @__route_string__ = ''
    end
    @__route_string__ << binding_name.to_s
    
  end
  
  #################################
  #  __initialize_for_ancestor__  #
  #################################
  
  def __initialize_for_ancestor__( ancestor_binding = nil )
        
    # To set up cascading configurations we need to register our parent/child inheritance tree.
    # We already have this set up in parallel by way of the bound instances.
    # So we need to see if our bound instance has an ancestor; if it does, get our parallel
    # binding of the same name and register it as parent of self.
    ccv = ::CascadingConfiguration::Variable
    
    if ancestor_binding

      ccv.register_child_for_parent( self, ancestor_binding )
      
    else
      
      ccv.configurations( self.class ).each do |this_configuration_name, true_value|
        ccv.register_configuration( self, this_configuration_name )
        ccv.register_parent_for_configuration( self, self.class, this_configuration_name )
      end

      __initialize_default_values__

    end

  end
  
  ###################################
  #  __initialize_default_values__  #
  ###################################
  
  def __initialize_default_values__

    self.__required__                  = false
    
  end
  
  ################################################
  #  __initialize_sub_bindings_for_view_class__  #
  ################################################
  
  def __initialize_sub_bindings_for_view_class__( view_class = nil )
    
    @__sub_bindings__ ? @__sub_bindings__.clear : @__sub_bindings__ = { }
    @__shared_sub_bindings__ ? @__shared_sub_bindings__.clear : @__shared_sub_bindings__ = { }
		
    # Define a method for each binding defined in default view for this binding.
    # 
	  # Obviously, we can only do this if we have a default view class.
	  # 
	  # If we have a default view class defined and are later assigned a view instance, then the 
	  # instance is expected to respond to any methods that have values defined in the enclosing view.
	  # In other words, if we have class Document containing HTML, which has Head and Body, and if
	  # Document.Title = Document.HTML.Title, then if instance document.title is set to 'title'
	  # we expect instance document to answer to :html and the result to answer to :title=, 
	  # or in other words: document.html.title = 'title'.
	  #
    if self.__view_class__ = view_class
  	  
  		unless view_class.respond_to?( :__bindings__ )
    		raise ::Magnets::Bindings::Exception::ViewClassLacksBindings,
    		        'Class ' + view_class.to_s + ' was declared as a view class, ' +
    		        'but does not respond to :' + :__bindings__.to_s + '.'
		  end

      base_route = nil
  		if @__route__
  		  base_route = @__route__.dup
		  else
  		  base_route = [ ]
  		end
  		base_route.push( __name__ )

      __initialize_sub_bindings__( view_class, base_route )
		  __initialize_sub_shared_bindings__( view_class, base_route )
	  
	  end
  	  		  
  end

  #################################
  #  __initialize_sub_bindings__  #
  #################################

  def __initialize_sub_bindings__( view_class, base_route )

		view_class.__bindings__.each do |this_binding_name, this_binding_instance|

      this_sub_binding = this_binding_instance.__duplicate_as_inheriting_sub_binding__( base_route )

      @__sub_bindings__[ this_binding_name ] = this_sub_binding

      #====================#
      #  sub_binding_name  #
      #====================#

      define_singleton_method( this_binding_name ) do

  	    return @__sub_bindings__[ this_binding_name ]

      end
      
	  end

  end

  ########################################
  #  __initialize_sub_shared_bindings__  #
  ########################################

  def __initialize_sub_shared_bindings__( view_class, base_route )

		view_class.__shared_bindings__.each do |this_binding_name, this_binding_instance|

      this_shared_binding_instance = nil

      if this_shared_binding_route = this_binding_instance.__route__
        # with shared bindings, instead of duplicating the binding we want to get
        # the equivalent binding that we have already duplicated from __bindings__
        this_shared_binding_name = this_binding_instance.__name__
        this_shared_binding_instance = __shared_binding_for_route__( this_shared_binding_route, 
                                                                     this_shared_binding_name )
      end

      @__shared_sub_bindings__[ this_binding_name ] = this_shared_binding_instance

      #===========================#
      #  shared_sub_binding_name  #
      #===========================#

      define_singleton_method( this_binding_name ) do

  	    return @__shared_sub_bindings__[ this_binding_name ]

      end
      
	  end

  end

end
