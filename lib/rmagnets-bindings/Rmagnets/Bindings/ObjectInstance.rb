
module ::Rmagnets::Bindings::ObjectInstance
	
  include ::CascadingConfiguration::Array
  include ::CascadingConfiguration::Hash
  
  # We rely on inheritance structure provided by CascadingConfiguration for Binding configuration.
  # Binding instance uses configuration instance (instance including this module) for 
  # defining parallel hierarchy.
  
	attr_configuration_hash   :binding_configurations, :shared_binding_routers,
	                          :binding_routers, :binding_aliases
  attr_configuration_array  :binding_order

  ################
  #  initialize  #
  ################

  def initialize

    @binding_instance_routers = { }
    
		# instantiate binding instance routers for this view class

		self.class.binding_routers.each do |this_binding_name, this_binding_router|
		  
		  new_instance_router = ::Rmagnets::Bindings::Binding::
  	                          Router::Instance.new( this_binding_router )

  		@binding_instance_routers[ this_binding_name ] = new_instance_router
      
	  end

		self.class.shared_binding_routers.each do |this_binding_name, this_shared_binding_router|
		  
		  path = this_shared_binding_router.__binding_path__
		  
		  shared_instance_router = self
		  
		  path.each do |this_binding_path_name|
		    shared_instance_router = shared_instance_router.__send__( this_binding_path_name )
	    end

      @binding_instance_routers[ this_binding_name ] = shared_instance_router

	  end
		
  end
  
  ####################
  #  binding_router  #
  ####################
  
  def binding_router( binding_name )
    
    unless binding_instance_router = @binding_instance_routers[ binding_name ]
  		raise ::Rmagnets::Bindings::Exception::NoBindingError,
  		      'No binding defined for :' + binding_name.to_s + '.'      
    end
    
    return binding_instance_router
    
  end
  
  ####################
  #  bound?  #
  ####################

  # bound? :name, ...
  # 
	def bound?( binding_name )
		
		return binding_router( binding_name ).bound?
		
	end
		
	############
  #  unbind  #
  ############
  
  def unbind( binding_name )
    
    binding_router( binding_name ).clear
    
  end
  
end
