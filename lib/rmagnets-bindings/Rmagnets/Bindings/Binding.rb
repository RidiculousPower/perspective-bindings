
class ::Rmagnets::Bindings::Binding

  include ::CascadingConfiguration::Setting
  
  attr_configuration :view_class, :configuration_proc, :required?, :text_only?

  attr_reader :name, :bound_instance

  ################
  #  initialize  #
  ################

  def initialize( bound_instance, 
                  binding_name, 
                  default_view_class = nil, 
                  is_required = nil,
                  is_text_only = nil,
                  & configuration_proc )
    
    @bound_instance = bound_instance
    @name = binding_name
    
    # check to see if binding_instance has parent with bindings
    # if so we want to chain our bindings with them
    # this insures that binding instances inherit properly while not actually being ancestors
    if binding_ancestor = ::CascadingConfiguration::Variable.ancestor( bound_instance, 
                                                                       binding_name )

      ancestor_binding = binding_ancestor.binding_instance( binding_name )

      ::CascadingConfiguration::Variable.register_child_for_parent( self, ancestor_binding )

    else
      
      # init default to false
      # if specified explicitly in parameters then it will be set again below
      self.required = false

    end
    
    unless default_view_class.nil?
      self.view_class = default_view_class
    end

    unless is_required.nil?
      self.required = is_required
    end

    unless is_text_only.nil?
      self.text_only = is_text_only
    end

    if block_given?
      self.configuration_proc = configuration_proc
    end
    
  end
	
	##################
  #  set_required  #
  ##################
  
	def set_required
	  
	  self.required = true
	  
  end

  ##################
  #  set_optional  #
  ##################
  
  def set_optional

	  self.required = false

  end
  
  ###############
  #  optional?  #
  ###############
  
  def optional?

    return ! required?

  end
  
  ###############
  #  required=  #
  ###############
  
  def required=( true_or_false )
    
    super( true_or_false ? true : false )

  end
	
end
