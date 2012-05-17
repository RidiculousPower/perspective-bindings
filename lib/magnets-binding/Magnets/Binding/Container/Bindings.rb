
module ::Magnets::Binding::Container::Bindings

  # include in container
  # * creates container::BindingMethods module (for bindings)
  # * creates container::InstanceBinding class
  # * includes container::BindingMethods in container::InstanceBinding
  
  # declaration of binding in container
  # * adds method to container::BindingMethods
  # * extends instance of class binding with container::BindingMethods
  
  # instantiation of container
  # * gets new instance binding from each class binding




  
  ##################################
  #  __initialize_view_bindings__  #
  ##################################
  
  def __initialize_view_bindings__( view_class = nil )
    
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
    		raise ::Magnets::Binding::Exception::ViewClassLacksBindings,
    		        'Class ' + view_class.to_s + ' was declared as a view class, ' +
    		        'but does not respond to :' + :__bindings__.to_s + '.'
		  end

      base_route = nil
  		if route = __route__
  		  base_route = route.dup
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
        this_binding_context = ::Magnets::Binding::Container.context( this_shared_binding_name,
                                                                      self,
                                                                      this_shared_binding_route,
                                                                      this_shared_binding_name )
        this_shared_binding_instance = this_binding_context.__binding__( this_shared_binding_name )
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
