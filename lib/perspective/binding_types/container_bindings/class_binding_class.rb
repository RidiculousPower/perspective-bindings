# -*- encoding : utf-8 -*-

module ::Perspective::BindingTypes::ContainerBindings::ClassBindingClass

  #########################################
  #  initialize«container_class_support»  #
  #########################################
  
  def initialize«container_class_support»( container_class = «container_class» )

    if container_class
      extend( container_class::ClassBindingMethods )
      ::CascadingConfiguration.register_singleton_to_singleton( self, container_class )
    end
  
  end

  ############
  #  «root»  #
  ############
  
  def «root»
    
    # class binding classes are never nested, only instances are
    
    return self
    
  end

  ##############
  #  is_root?  #
  ##############
  
  def is_root?
    
    return true
    
  end
  
  ###################
  #  «root_string»  #
  ###################

  def «root_string»
    
    # [root:<instance>]

    return @«root_string» ||= '<class-binding-class:' << to_s << '>'
    
  end

  #############
  #  «route»  #
  #############

  def «route»
    
    # class binding classes are never nested, only instances are
    
    return nil
    
  end

  #######################
  #  «route_with_name»  #
  #######################

  def «route_with_name»
    
    return nil
    
  end

  #####################
  #  route_with_name  #
  #####################

  alias_method( :route_with_name, :«route_with_name» )

end
