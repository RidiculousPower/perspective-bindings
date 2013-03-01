# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Container::SingletonAndObjectInstance
  
  ######################
  #  «route_string»  #
  ######################

  def «route_string»
    
    route_string = nil
    
    if @«parent_binding»
      route_string = @«parent_binding».«route_string»
    end
    
    return route_string
    
  end

  ##################
  #  route_string  #
  ##################

  alias_method( :route_string, :«route_string» )

  ############################
  #  «route_print_string»  #
  ############################

  def «route_print_string»

    route_print_string = nil
    
    if @«parent_binding»
      route_print_string = @«parent_binding».«route_print_string»
    else
      unless route_print_string = «route_string»
        @«route_print_string» ||= ::Perspective::Bindings.context_print_string( «root», «route_string» )
        route_print_string = @«route_print_string»
      end
    end
    
    return route_print_string
    
  end

  ########################
  #  route_print_string  #
  ########################

  alias_method( :route_print_string, :«route_print_string» )
  
end

