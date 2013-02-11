
module ::Perspective::Bindings::Container::MultiContainerProxy::MultiContainerProxyInterface

  ################
  #  initialize  #
  ################

  def initialize( parent_instance_binding, *data_objects )

    # we assume all classes in the container are the same
    @__parent_binding__ = parent_instance_binding

    current_container = parent_instance_binding.__container__

    # we ask the instance what class it is since that could change at runtime from
    # the class binding configuration
    @__container_class__ = current_container.class

    @__storage_array__ = [ current_container ]

    __autobind__( data_objects )

  end

  ####################
  #  method_missing  #
  ####################

  def method_missing( method, *args )

    return @__storage_array__.collect { |this_container| this_container.__send__( method, *args ) }

  end

  #########################
  #  respond_to_missing?  #
  #########################

  def respond_to_missing?( name, include_private = false )

    return true

  end

  ###########
  #  class  #
  ###########

  def class

    return ::Perspective::Bindings::Container::MultiContainerProxy

  end

  ########################
  #  __parent_binding__  #
  ########################

  attr_reader :__parent_binding__
  
  #########################
  #  __container_class__  #
  #########################

  # returns class of container it expects to be addressing
  attr_reader :__container_class__

  #####################################
  #  __create_additional_container__  #
  #####################################

  def __create_additional_container__( index )
    
    new_container_instance = @__container_class__.new_nested_instance( @__parent_binding__ )

    __push__( new_container_instance )
    
    new_container_instance.__initialize_for_index__( index )

    return new_container_instance
    
  end

  ##################
  #  __autobind__  #
  ##################
  
  def __autobind__( data_object, method_map_hash = nil )

    container_class = nil

    case data_object
      
      when ::Array

        data_object.each_with_index do |this_object, this_index|
          this_container_instance = nil
          if __size__ > this_index
            this_container_instance = self[ this_index ]
          else
            this_container_instance = __create_additional_container__( this_index )
          end
          this_container_instance.__autobind__( this_object, method_map_hash )
        end

      else
      
        each { |this_container| this_container.__autobind__( this_object, method_map_hash ) }
      
    end

    return self

  end

  ##############
  #  autobind  #
  ##############

  alias_method :autobind, :__autobind__

  #######################
  #  __storage_array__  # 
  #######################

  attr_reader :__storage_array__

  ##############
  #  __size__  #
  ##############

  def __size__

    return @__storage_array__.size

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

    return @__storage_array__.pop

  end

  ###############
  #  __shift__  #
  ###############

  def __shift__

    return @__storage_array__.shift

  end

  #################
  #  __unshift__  #
  #################

  def __unshift__( object )

    return @__storage_array__.unshift( object )

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
  
  ##########
  #  each  #
  ##########
  
  def each
    
    return to_enum unless block_given?
    
    @__storage_array__.each do |this_container|
      yield( this_container )
    end
    
    return self
    
  end
    
end
