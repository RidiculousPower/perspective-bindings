
class ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeClass
    
  #######################
  #  self.new_subclass  #
  #######################
  
  def self.new_subclass( parent_type_module )
    
    new_subclass = ::Class.new( self ) { @parent_type_module = parent_type_module }
    
    return new_subclass
    
  end
  
  #############################
  #  self.parent_type_module  #
  #############################
  
  class << self
    attr_reader :parent_type_module
  end
  
  ######################
  #  self.__include__  #
  ######################

  class << self
    alias_method :__include__, :include
  end
  
  #####################
  #  self.__extend__  #
  #####################

  class << self
    alias_method :__extend__, :extend
  end

  ##################
  #  self.include  #
  ##################
  
  def self.include( *modules )
    
    @parent_type_module.include( *modules )
    
    return self
    
  end

  #################
  #  self.extend  #
  #################
  
  def self.extend( *modules )

if $blah and $blah > 10
  raise 'wtf'
elsif $blah
  $blah += 1
else
  $blah = 0
end
    @parent_type_module.extend( *modules )    
    
    return self

  end

end
