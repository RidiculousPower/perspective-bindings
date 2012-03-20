
class ::Rmagnets::Bindings::Binding::Router

  #include ::CascadingConfiguration::Setting
  #include ::CascadingConfiguration::Hash

  attr_reader :__binding_instance__, :__binding_name__, :__binding_route__, 
              :__sub_routers__, :__shared_sub_routers__,
              :__configuration_procs__, :__validation_procs__

  #attr_configuration :__binding_instance__, :__binding_name__, :__binding_route__
  #
  #attr_configuration_hash :__sub_routers__, :__shared_sub_routers__

  ################
  #  initialize  #
  ################

  def initialize( binding_configuration_instance, base_path = nil )
    
    ccv = ::CascadingConfiguration::Variable

    ccv.register_configuration( self, binding_name )
    ccv.register_configuration( bound_module, binding_name )
    
    if binding_ancestor = ccv.ancestor_for_registered_instance( bound_module, binding_name )

        ancestor_binding = binding_ancestor.binding_configuration( binding_name )

        ::CascadingConfiguration::Ancestors.register_child_for_parent( self, ancestor_binding )

    else
    
    end
    
    @__binding_instance__ = binding_configuration_instance
    
    @__binding_name__ = binding_configuration_instance.__binding_name__
    
    @__binding_is_alias__ = false
    
    @__binding_route__ = base_path
		
		@__sub_routers__ = { }
		@__shared_sub_routers__ = { }
		
	  # Define a method for each binding defined in default view for this binding
	  # we can only do this if we have a default view class
	  # If we have a default view class and are given a view instance then the instance is expected
	  # to respond to any methods that have values defined in the enclosing view.
	  # In other words, if we have class Document containing HTML, which has Head and Body, and if
	  # Document.Title = Document.HTML.Title, then if instance document.title is set to 'title'
	  # we expect instance document to answer to :html and the result to answer to :title=, 
	  # or in other words: document.html.title = 'title'.
	  #
		if view_class = @__binding_instance__.view_class
  		
  		binding_route = nil
  		
  		unless view_class.respond_to?( :binding_configurations )
    		raise ::Rmagnets::Bindings::Exception::ViewClassLacksBindings,
    		      'Class ' + view_class.to_s + ' was declared as a view class, ' +
    		      'but does not respond to :' + :binding_configurations.to_s + '.'
		  end
  		
  		unless view_class.binding_configurations.empty?
  		  
  		  # set up binding route that local binding routers to view class bindings will use
    		if @__binding_route__
    		  binding_route = @__binding_route__.dup
    		else
    		  binding_route = [ ]
    		end
        
        # binding route is the name of our shared binding underneath the path to this router
		    binding_route.push( @__binding_name__ )

		  end
  		
      # for each method defined in the default view class for this binding
  		view_class.binding_routers.each do |this_binding_name, this_binding_router|
	  
        # Any view that can access a binding (ie in another view) has its own binding router
        # So if View.some_binding is aliased to View.other_binding.some_binding, both View
        # and OtherView (the default view class for View.other_binding) have binding routers.
        sub_binding_router = this_binding_router.duplicate_for_shared_router( binding_route )

        @__sub_routers__[ this_binding_name ] = sub_binding_router

  	    initialize_binding_route_methods( view_class, this_binding_name )
        
  	  end
  	  
  	  view_class.shared_binding_routers.each do |this_binding_name, this_shared_binding_router|
  	    
  		  shared_router_instance = self

        route = this_shared_binding_router.__binding_route__

  		  route.each do |this_binding_route_part|
  		    shared_router_instance = shared_router_instance.binding_router( this_binding_route_part )
  	    end
  	    
  	    @__shared_sub_routers__[ this_binding_name ] = shared_router_instance
        
  	    initialize_binding_route_methods( view_class, this_binding_name )
  	    
  		end
		  
		end
		
  end

  ######################################
  #  initialize_binding_route_methods  #
  ######################################

  def initialize_binding_route_methods( view_class, binding_name )
  
    #====================#
    #  sub_binding_name  #
    #====================#
    
  	eigenclass = class << self ; self ; end	
	  eigenclass.instance_eval do

	    define_method( binding_name ) do
    
		    return binding_router( binding_name )

      end
    
    end
    
  end
  
  ####################
  #  binding_router  #
  ####################
  
  def binding_router( binding_name )
    
    return @__sub_routers__[ binding_name ]
    
  end
  
  #################################
  #  duplicate_for_shared_router  #
  #################################
  
  def duplicate_for_shared_router( binding_base_route )
    
	  return ::Rmagnets::Bindings::Binding::Router.new( @__binding_instance__, binding_base_route )
	  
  end

  ###############
  #  configure  #
  ###############

  def configure( & configuration_proc )
        
    configuration_procs.push( [ configuration_proc, @bound_module.binding_configurations ] )
    
  end

  ##############
  #  validate  #
  ##############

  def validate( & validation_proc )

    validation_procs.push( [ configuration_proc, @bound_module.binding_configurations ] )

  end
    
end
