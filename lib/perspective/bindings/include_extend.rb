
module ::Perspective::Bindings::IncludeExtend
    
  ###################
  #  self.included  #
  ###################
    
  def self.included( module_or_class_instance )

    module_or_class_instance.module_eval do

      include( ::Perspective::Bindings::IncludeExtend::InitializeInstances )

    end
    
    super

  end

  ###################
  #  self.extended  #
  ###################

  def self.extended( module_or_class_instance )

    module_or_class_instance.module_eval do

      @child_binding_types = ::Array::Unique.new( self )

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
