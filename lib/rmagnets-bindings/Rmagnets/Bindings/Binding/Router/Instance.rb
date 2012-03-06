
class ::Rmagnets::Bindings::Binding::Router::Instance

  attr_reader :object

  ################
  #  initialize  #
  ################

  def initialize( binding_router )
    
    # we are an instance binding router, 
    # -which refers to a parent binding router,
    # --which refers to a parent binding instance,
    # ---which refers to a parent view class
    @binding_router = binding_router
	  
	  @__has_bound_object__ = false
	  
	  @__sub_bindings__ = { }
	  
	  # we are already creating an instance router for our parent binding router
	  # now, create an instance router for each sub-router in our parent binding router (and so on)
	  @binding_router.__sub_routers__.each do |this_binding_name, this_binding_sub_router|
      
	    # define binding instance routers for any binding sub-routers
	    new_sub_router_instance = self.class.new( this_binding_sub_router )
    
      initialize_binding_route_methods( this_binding_name, new_sub_router_instance )
      
    end

	  @binding_router.__shared_sub_routers__.each do |this_binding_name, this_binding_sub_router|
      
		  shared_instance_router = self
		  
		  path = this_binding_sub_router.__binding_instance__.__binding_path__
		  
		  path.each do |this_binding_path_name|
		    shared_instance_router = shared_instance_router.__send__( this_binding_path_name )
	    end
    
      initialize_binding_route_methods( binding_name, shared_instance_router )
      
    end
    		
  end

  ######################################
  #  initialize_binding_route_methods  #
  ######################################

  def initialize_binding_route_methods( binding_name, router_instance_binding )

    @__sub_bindings__[ binding_name ] = router_instance_binding

    accessor_write_name = binding_name.write_accessor_name
    accessor_is_set_name = binding_name.is_set_accessor_name
    
		eigenclass = class << self ; self ; end
	  eigenclass.instance_eval do

      ######################
      #  sub_binding_name  #
      ######################

      define_method( binding_name ) do
        
        # return sub router instance
        return binding_router( binding_name )
      
      end
    
      #######################
      #  sub_binding_name=  #
      #######################

	    define_method( accessor_write_name ) do |object_to_bind|

        # set binding to object instance
        binding_router( binding_name ).object = object_to_bind
      
      end

      #######################
      #  sub_binding_name?  #
      #######################

	    define_method( accessor_is_set_name ) do
      
        # return whether binding has been assigned object instance
        binding_router( binding_name ).bound?
      
      end

    end

  end

  ############
  #  unbind  #
  ############
  
  def unbind( binding_name )
    
    instance_binding_router = @__sub_bindings__[ binding_name ]
    
    instance_binding_router.clear
    
  end
  
  ###########
  #  clear  #
  ###########
  
  def clear

    @__has_bound_object__ = false
    @object = nil
    
  end

  ############
  #  bound?  #
  ############
  
  def bound?
    
    return @__has_bound_object__
    
  end
  
  ########################
  #  binding_router  #
  ########################

  def binding_router( binding_name )
    
    return @__sub_bindings__[ binding_name ]
    
  end

  #############
  #  object=  #
  #############
  		
  def object=( object )
    
    @__has_bound_object__ = true
    
    @object = object
    
  end
  
end

