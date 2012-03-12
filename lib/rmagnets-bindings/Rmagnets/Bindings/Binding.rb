
class ::Rmagnets::Bindings::Binding

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array
  
  # We declare as cascading configurations so that bindings can inherit configurations
  # in parallel with class/module inheritance tree (to which they are bound).
  # Inheritance is accomplished using CascadingConfiguration::Variable functionality;
  # for details, see #initialize.
  attr_configuration_array  :configuration_procs
  attr_configuration        :__binding_name__, :view_class, :corresponding_view_binding, :required?, 
                            :multiple_values_permitted?, :text_permitted?, :number_permitted?, 
                            :integer_permitted?, :float_permitted?, :complex_permitted?,
                            :rational_permitted?, :regexp_permitted?, 
                            :module_permitted?, :class_permitted?, :true_false_permitted?,
                            :file_permitted?, :view_permitted?, :object_permitted?
  
  attr_reader :bound_module

  ################
  #  initialize  #
  ################

  def initialize( bound_module, binding_name, view_class = nil, & configuration_proc )
    
    self.__binding_name__ = binding_name
    
    @bound_module = bound_module
    
    # To set up cascading configurations we need to register our parent/child inheritance tree.
    # We already have this set up in parallel by way of the bound instances.
    # So we need to see if our bound instance has an ancestor; if it does, get our parallel
    # binding of the same name and register it as parent of self.
    if binding_ancestor = ::CascadingConfiguration::Variable.ancestor( bound_module, 
                                                                       binding_name ) and
       binding_ancestor.is_a?( ::Rmagnets::Bindings::ClassInstance )
        
        ancestor_binding = binding_ancestor.binding_configuration( binding_name )
        
        ::CascadingConfiguration::Variable.register_child_for_parent( self, ancestor_binding )
      
    else
      
      # init defaults to false
      # if specified explicitly in parameters then it will be set again below

      self.required                  = false
      self.multiple_values_permitted = false
      self.text_permitted            = false
      self.number_permitted          = false
      self.integer_permitted         = false
      self.float_permitted           = false
      self.complex_permitted         = false
      self.rational_permitted        = false
      self.regexp_permitted          = false
      self.module_permitted          = false
      self.class_permitted           = false
      self.true_false_permitted      = false
      self.file_permitted            = false
      self.view_permitted            = false
      self.object_permitted          = false

    end
    
    unless view_class.nil?
      self.view_class = view_class
    end
    
    if block_given?
      configuration( & configuration_proc )
    end
    
  end
  
	###################################  Runtime Verification  #######################################

  ################################
  #  ensure_binding_value_valid  #
  ################################

  def ensure_binding_value_valid( binding_value )

    case binding_value
      
      when nil
      
        # nothing required
      
      when Array
        
        unless multiple_values_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Multiple values given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
        binding_value.each do |this_binding_value|
          ensure_binding_value_valid( this_binding_value )
        end
      
      when String, Symbol

        unless object_permitted? or text_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'String given ("' + binding_value.inspect.to_s + '") but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
      when Integer
        
        unless object_permitted? or number_permitted? or integer_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Integer given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
      when Float
      
        unless object_permitted? or number_permitted? or float_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Float given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
      
      when Complex
        
        unless object_permitted? or number_permitted? or complex_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Complex given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
      when Rational

        unless object_permitted? or number_permitted? or rational_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Rational given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
      when Regexp
        
        unless object_permitted? or regexp_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Regexp given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
      when Class

        unless object_permitted? or module_permitted? or class_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Regexp given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
      when Module

        unless object_permitted? or module_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Regexp given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
      when TrueClass, FalseClass

        unless object_permitted? or true_false_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'True/False given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
      when File
        
        unless object_permitted? or file_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'File given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __binding_name__.to_s
        end
        
      else

        if binding_value.respond_to?( :to_html_node )     or 
           binding_value.respond_to?( :to_html_fragment )

          unless object_permitted? or view_permitted?
            raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError,
                    'View given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                    'binding configuration for binding :' + __binding_name__.to_s
          end
          
        else
        
          unless object_permitted?
            raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError,
                    'Object given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                    'binding configuration for binding :' + __binding_name__.to_s
          end
          
        end
              
    end

  end

  #######################################
  #  ensure_binding_render_value_valid  #
  #######################################

  def ensure_binding_render_value_valid( binding_value )

    # if binding is required and has a nil value, raise exception
		unless binding_value or optional?

			raise ::Rmagnets::Bindings::Exception::BindingRequired,
			        'Binding :' + __binding_name__.to_s + ' is required but not bound for binding :' + 
			        __binding_name__.to_s + ' (' + @bound_module.to_s + ').'

		end
		
	end
	
	#########################################  Options  ##############################################
	
  ###################
  #  configuration  #
  ###################

  def configuration( & configuration_proc )
        
    configuration_procs.push( [ configuration_proc, @bound_module.binding_configurations ] )
    
  end

  ###############
  #  optional?  #
  ###############
  
  def optional?

    return ! required?

  end
  
end
