
module ::Magnets::Binding::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash

  ccm = ::CascadingConfiguration::Methods

  ###############
  #  route      #
  #  __route__  #
  ###############

  attr_instance_configuration  :__route__

  ccm.alias_instance_method( self, :route, :__route__ )

  ######################
  #  route_string      #
  #  __route_string__  #
  ######################

  attr_instance_configuration  :__route_string__

  ccm.alias_instance_method( self, :route_string, :__route_string__ )

  ##################
  #  bindings      #
  #  __bindings__  #
  ##################

	attr_instance_configuration_hash  :__bindings__ do

	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( binding_name, binding_instance )

      child_instance = nil

      case configuration_instance

        when ::Magnets::Binding::Container::ClassInstance, 
             ::Magnets::Binding::ClassBinding

          binding_instance.instance_eval do
            # Create a new binding without any settings - causes automatic lookup to superclass.
            base_route = binding_instance.__route__
            child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__( base_route )
          end

        when ::Magnets::Binding::Container::ObjectInstance, 
             ::Magnets::Binding::InstanceBinding

          child_instance = binding_instance.class::InstanceBinding.new( binding_instance )

      end


      return child_instance

    end

  end

  ccm.alias_instance_method( self, :bindings, :__bindings__ )

	#################
  #  binding      #
  #  __binding__  #
  #################
    
  def __binding__( binding_name )
    
    return __bindings__[ binding_name ]   
    
  end
  alias_method  :binding, :__binding__
  
end
