
module ::Perspective::Bindings::BindingTypeContainer::IncludeExtend
  
  include ::CascadingConfiguration::Array::Unique
  
  extend ::Module::Cluster
  cluster = cluster( :binding_type_class_module )

  ####################
  #  extend_modules  #
  ####################

  attr_unique_array :extend_modules

  #####################
  #  include_modules  #
  #####################

  attr_unique_array :include_modules
  
  #################
  #  __include__  #
  #################
  
  ###
  # Original #include method for extending this class binding instance. Renamed to permit
  #   #include to be used for configuring corresponding bindings.
  #
  cluster.before_extend.cascade_to( :class ) do |hooked_class|    
    hooked_class.class_eval do
      class << self
        alias_method( :__include__, :include )
      end
    end
  end

  ################
  #  __extend__  #
  ################
  
  ###
  # Original #extend method for extending this class binding instance. Renamed to permit
  #   #extend to be used for configuring corresponding bindings.
  #
  cluster.before_extend.cascade_to( :class ) do |hooked_class|    
    hooked_class.class_eval do
      class << self
        alias_method( :__extend__, :extend )
      end
    end
  end

  #############
  #  include  #
  #############
  
  ###
  # Cause instance bindings corresponding to this class binding to be extended by provided module(s).
  #  
  def include( *modules, & new_module_block )
    
    if block_given?
      new_include_module = ::Module.new( & new_module_block )
      modules.unshift( new_include_module )
    end
    
    # Store the modules somewhere so that instances can use them.
    # We keep youngest first so that we can simply "include( *include_modules )" later.
    include_modules.unshift( *modules )
  
    return self
    
  end
  
  ############
  #  extend  #
  ############
  
  ###
  # Cause instance bindings corresponding to this class binding to be extended by provided module(s).
  #  
  def extend( *modules, & new_module_block )
    
    if block_given?
      new_extend_module = ::Module.new( & new_module_block )
      modules.unshift( new_extend_module )
    end
    
    # Store the modules somewhere so that instances can use them.
    # We keep youngest first so that we can simply "extend( *extend_modules )" later.
    extend_modules.unshift( *modules )
  
    return self
    
  end
  
end
