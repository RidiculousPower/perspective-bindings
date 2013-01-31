
module ::Perspective::Bindings::IncludeExtend
    
  ###################
  #  self.included  #
  ###################
    
  def self.included( module_or_class_instance )

    module_or_class_instance.module_eval do

      include( ::Perspective::Bindings::IncludeExtend::InitializeInstances )

      #################
      #  __include__  #
      #################

      alias_method :__include__, :include

      ################
      #  __extend__  #
      ################

      alias_method :__extend__, :extend

    end
    
    super

  end

  ###################
  #  self.extended  #
  ###################

  def self.extended( module_or_class_instance )

    module_or_class_instance.module_eval do

      @child_binding_types = ::Array::Unique.new( self )

      #################
      #  __include__  #
      #################

      alias_module_method :__include__, :include

      ################
      #  __extend__  #
      ################

      alias_module_method :__extend__, :extend

    end

    super

  end
  
  ##############
  #  included  #
  ##############
  
  def included( module_instance )

    @child_binding_types.push( module_instance )
    
    super
    
  end

  
  #############
  #  include  #
  #############
  
  def include( *modules )
    
    super
    
    _binding_base = self

    @child_binding_types.each do |this_child_binding_type|
      this_child_binding_type.module_eval { include( _binding_base ) }
    end
    
    return self
    
  end

  ############
  #  extend  #
  ############

  def extend( *modules )

    super

    @child_binding_types.each do |this_child_binding_type|
      this_child_binding_type.extend( *modules )
    end
    
    return self
    
  end

end
