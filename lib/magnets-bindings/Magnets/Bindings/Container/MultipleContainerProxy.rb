
class ::Magnets::Bindings::Container::MultipleContainerProxy < ::BasicObject

  # a proxy for multiple views
  
  ################
  #  initialize  #
  ################
  
  def initialize( container_class )

    # we assume all classes in the container are the same
    @__container_class__ = container_class
    
    @__storage_array__ = [ ]
    
  end

  ####################
  #  method_missing  #
  ####################
  
  def method_missing( method, *args )
    
    return @__storage_array__.__send__( method, *args )
    
  end

  #########################
  #  respond_to_missing?  #
  #########################

  def respond_to_missing?( name, include_private = false )

    return true

  end
  
  #########################
  #  __container_class__  #
  #########################
  
  # returns class of container it expects to be addressing
  def __container_class__( container_class )
    
    @__container_class__ = container_class
    
  end
  
  #######################
  #  __storage_array__  # 
  #######################
  
  def __storage_array__
    
    return @__storage_array__
    
  end
  
  ##############
  #  __push__  #
  ##############
  
  def __push__( object )
    
    return @__storage_array__.push( object )
    
  end

  #############
  #  __pop__  #
  #############
  
  def __pop__
    
    return @__storage_array__.pop( object )
    
  end

  ###############
  #  __shift__  #
  ###############
  
  def __shift__
    
    return @__storage_array__.shift( object )
    
  end
  
  ########
  #  []  #
  ########
  
  def []( index )
    
    return @__storage_array__[ index ]
    
  end
  
  #########
  #  []=  #
  #########
  
  def []=( index, object )
    
    return @__storage_array__[ index ] = object
    
  end
  
end
