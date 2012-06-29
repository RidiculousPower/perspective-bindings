
module ::Magnets::Bindings::Container::MultiContainerProxy::Interface

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

    __autobind__( *data_objects )

  end

  ########################
  #  __parent_binding__  #
  ########################

  attr_reader :__parent_binding__
  
  ###########
  #  class  #
  ###########

  def class

    return ::Magnets::Bindings::Container::MultiContainerProxy

  end

  ####################
  #  method_missing  #
  ####################

  def method_missing( method, *args )

    results = [ ]

    @__storage_array__.each do |this_container|
      results.push( this_container.__send__( method, *args ) )
    end

    return results

  end

  #########################
  #  respond_to_missing?  #
  #########################

  def respond_to_missing?( name, include_private = false )

    return true

  end

  ##################
  #  autobind      #
  #  __autobind__  #
  ##################

  def __autobind__( *data_objects )

    container_class = nil

    data_objects.each_with_index do |this_object, this_index|

      this_container_instance = nil

      if __count__ > this_index

        this_container_instance = self[ this_index ]

      else

        this_container_instance = __create_new_view_for_autobind__

        __push__( this_container_instance )

      end

      this_container_instance.__autobind__( this_object )

    end

    return self

  end

  alias_method :autobind, :__autobind__

  ######################################
  #  __create_new_view_for_autobind__  #
  ######################################

  def __create_new_view_for_autobind__

    new_container_instance = @__container_class__.new
    parent_class_binding = @__parent_binding__.__parent_binding__
    new_container_instance.__initialize_for_parent_binding__( parent_class_binding )

    return new_container_instance

  end

  #########################
  #  __container_class__  #
  #########################

  # returns class of container it expects to be addressing
  def __container_class__

    return @__container_class__

  end

  #######################
  #  __storage_array__  # 
  #######################

  attr_reader :__storage_array__

  ###############
  #  __count__  #
  ###############

  def __count__

    return @__storage_array__.count

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
    
end
