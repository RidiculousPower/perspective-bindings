
class ::Rmagnets::Bindings::Binding::Proxy

  ################
  #  initialize  #
  ################

  def initialize( configuration_proc, binding_map )

    @configuration_proc = configuration_proc
    
    # copy the current binding configuration map
    # we will use this to route the proxy for the configuration proc
    @binding_map = binding_map.dup

  end

  ###########################################
  #  proxy_bindings_for_configuration_proc  #
  ###########################################
  
  def proxy_bindings_for_configuration_proc( proxy_for_instance, *args )
    
    @proxy_for_instance = proxy_for_instance
    
    self.instance_exec( *args, & @configuration_proc )

    # now transfer over any instance variables (since we couldn't hook them)

    __transfer_instance_variables__
    
    @proxy_for_instance = nil
    
  end

  #####################################
  #  __transfer_instance_variables__  #
  #####################################
  
  def __transfer_instance_variables__
    
    # we can't hook instance variables but we _can_ transfer them over -
    # before and after any method call
    instance_variables.delete_if do |this_variable|
      variable_value = instance_variable_get( this_variable )
      @proxy_for_instance.instance_variable_set( this_variable, variable_value )
      true
    end
    
  end

  ####################
  #  method_missing  #
  ####################
  
  def method_missing( method_name, *args )
    
    return_value = nil
    
    __transfer_instance_variables__
    
    binding_name = method_name.accessor_name

    # if our method names a binding, route to the binding
    if binding_instance = @binding_map[ binding_name ]
    
      # for a given name we need to know the current path to its equivalent instance
    
      case method_name

        when binding_name

          binding_accessor_name = binding_instance.__binding_name__.accessor_name
          return_value = @proxy_for_instance.__send__( binding_accessor_name, *args )

        when binding_name.write_accessor_name

          binding_write_accessor_name = binding_instance.__binding_name__.write_accessor_name
          return_value = @proxy_for_instance.__send__( binding_write_accessor_name, *args )

      end
    
    # otherwise, route to the normal object context
    else
      
      return_value = @proxy_for_instance.__send__( method_name, *args )
      
    end
    
    __transfer_instance_variables__
    
    return return_value
    
  end
  
end
