
module ::Perspective::Bindings::BindingBase

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::Configuration::ObjectAndBindingInstance

  include ::CascadingConfiguration::Setting
  
  @child_binding_types = ::Array::Unique.new( self )
  
  ###################
  #  self.included  #
  ###################
  
  def self.included( module_instance )

    @child_binding_types.push( module_instance )
    
    super
    
  end

  ######################
  #  self.__include__  #
  ######################
  
  alias_module_method :__include__, :include
  
  ##################
  #  self.include  #
  ##################
  
  def self.include( *modules )
    
    super
    
    _binding_base = self

    @child_binding_types.each do |this_child_binding_type|
      this_child_binding_type.module_eval { include( _binding_base ) }
    end
    
    return self
    
  end

  #####################
  #  self.__extend__  #
  #####################

  alias_module_method :__extend__, :extend
  
  #################
  #  self.extend  #
  #################

  def self.extend( *modules )

    super

    @child_binding_types.each do |this_child_binding_type|
      this_child_binding_type.extend( *modules )
    end
    
    return self
    
  end

  #########################
  #  __bound_container__  #
  #########################

  attr_reader  :__bound_container__

  ##############
  #  __name__  #
  ##############
  
  attr_instance_configuration  :__name__

  ##############
  #  __root__  #
  ##############
  
  attr_reader  :__root__

  ###############
  #  __route__  #
  ###############

  attr_instance_configuration  :__route__

  #########################
  #  __route_with_name__  #
  #########################

  attr_instance_configuration  :__route_with_name__

  ######################
  #  __route_string__  #
  ######################

  attr_instance_configuration  :__route_string__

  ############################
  #  __route_print_string__  #
  ############################

  attr_instance_configuration  :__route_print_string__

  ###########################
  #  __permits_multiple__?  #
  #  __permits_multiple__=  #
  ###########################
  
  attr_configuration  :__permits_multiple__?
  
  self.__permits_multiple__ = false
  
  ###################
  #  __required__?  #
  #  __required__=  #
  ###################

  attr_configuration  :__required__?

  self.__required__ = false

  ###################
  #  __optional__?  #
  ###################
  
  def __optional__?
  
    return ! __required__?
  
  end

  ###################
  #  __optional__=  #
  ###################
  
  def __optional__=( true_or_false )
  
    return self.__required__=( ! true_or_false )
  
  end
  
end
