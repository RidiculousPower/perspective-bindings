
module ::Magnets::Bindings::AttributeDefinitionModule
  
  ###################
  #  self.extended  #
  ###################
  
  def self.extended( attribute_definition_module )
    
    attribute_definition_module.module_eval do
      @modules_including_self = { }
    end
    
  end

  ##############
  #  included  #
  ##############
  
  def included( attribute_definition_module )
    
    unless @modules_including_self.has_key?( attribute_definition_module )
      @modules_including_self[ attribute_definition_module ] = true
    end
    
  end

  #############
  #  include  #
  #############
  
  def include( *modules )
    
    super
    
    reference_to_self = self
    
    @modules_including_self.each do |this_module, true_value|
      this_module.module_eval do
        include reference_to_self
      end
    end
    
  end
  
end
