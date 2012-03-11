
class ::Rmagnets::Bindings::Binding::Router

  attr_reader :__binding_instance__, :__binding_name__, :__binding_route__, 
              :__sub_routers__, :__shared_sub_routers__

  include ::CascadingConfiguration::Setting

  ################
  #  initialize  #
  ################

  def initialize( binding_configuration_instance, base_path = nil )
    
    @__binding_instance__ = binding_configuration_instance
    
    @__binding_name__ = @__binding_instance__.__binding_name__
    
    @__binding_is_alias__ = false
    
    @__sub_routers__ = { }
    @__shared_sub_routers__ = { }
    
    @__binding_route__ = base_path
		
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
  		
    		if @__binding_route__
    		  binding_route = @__binding_route__.dup
    		else
    		  binding_route = [ ]
    		end

		    binding_route.push( @__binding_instance__.__binding_name__ )

		  end
  		
      # for each method defined in the default view class for this binding
  		view_class.binding_routers.each do |this_binding_name, this_binding_router|
	  
        # Any view that can access a binding (ie in another view) has its own binding router
        # So if View.some_binding is aliased to View.other_binding.some_binding, both View
        # and OtherView (the default view class for View.other_binding) have binding routers.
        sub_binding_router = view_class.binding_router( this_binding_name, binding_route )

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
  
  ##################################
  #  binding_router  #
  ##################################
  
  def binding_router( binding_name )
    
    return @__sub_routers__[ binding_name ]
    
  end
  
end
