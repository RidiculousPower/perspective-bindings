# -*- encoding : utf-8 -*-

module ::Perspective::BindingTypes::ContainerBindings::ClassBindingClassAndBinding

  extend ::CascadingConfiguration::Setting

  ################################
  #  «validate_container_class»  #
  ################################

  def «validate_container_class»( container_class )
    	  
		unless container_class.respond_to?( :«bindings» )
  		raise ::Perspective::Bindings::Exception::ContainerClassLacksBindings,
  		        'Class ' << container_class.to_s << ' was declared as a container class, ' <<
  		        'but does not respond to :«bindings».'
	  end
    
  end

  #########################################
  #  initialize«container_class_support»  #
  #########################################
  
  def initialize«container_class_support»( container_class = «container_class» )

    if container_class
      extend( container_class::ClassBindingMethods )
      ::CascadingConfiguration.register_singleton_to_instance( self, container_class )
    end
  
  end

  #######################
  #  «container_class»  # 
  #######################

  attr_instance_configuration  :«container_class»

  ########################
  #  «container_class»=  #
  ########################

  def «container_class»=( container_class )
    
    «validate_container_class»( container_class )

    initialize«container_class_support»( container_class )
    
    return super
    
  end

  #####################
  #  container_class  #
  #####################

  alias_method( :container_class, :«container_class» )

  ######################
  #  container_class=  #
  ######################

  alias_method( :container_class=, :«container_class»= )

end
