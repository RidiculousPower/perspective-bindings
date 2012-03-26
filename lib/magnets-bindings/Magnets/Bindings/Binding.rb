
class ::Rmagnets::Bindings::Binding

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array

  #################################
  #  self.shared_binding_context  #
  #################################

  def self.shared_binding_context( shared_alias_name, starting_context, binding_route, accessor )

    binding_context = starting_context
    
    route_successfully_mapped = [ ]
    
    binding_route.each_with_index do |this_binding_route_part, index|

      unless binding_context.respond_to?( this_binding_route_part )
    		raise ::Rmagnets::Bindings::Exception::NoBindingError,
      		      starting_context.to_s + ' does not have route :' + 
      		      binding_route.slice( 0, index ).join( '.' ) + '.' + "\n\n" +
      		      'Shared binding route :' + this_binding_route_part.to_s + 
      		      ' was inaccessible in context :' + route_successfully_mapped.join( '.' ) +
        	      ' (' + binding_context.inspect + '). '
      end
      
      binding_context = binding_context.__send__( this_binding_route_part )

      route_successfully_mapped.push( this_binding_route_part )

    end

    unless binding_context.respond_to?( accessor )
  		raise ::Rmagnets::Bindings::Exception::NoBindingError,
      	      'No accessor :' + accessor.to_s + ' defined ' + 'in ' + 
      	      ( [ binding_context.inspect ] + binding_route ).join( '.' ) + '.' + "\n\n" + 
      	      'Shared binding :' + shared_alias_name.to_s + ' was inaccessible in ' + 
      	      self.to_s + '.'
    end
    
    return binding_context
    
  end
  
  # We declare as cascading configurations so that bindings can inherit configurations
  # in parallel with class/module inheritance tree (to which they are bound).
  # Inheritance is accomplished using CascadingConfiguration::Variable functionality;
  # for details, see #initialize.
  
  # Identity
  # --------
  # 
  attr_configuration        :__name__, :__view_class__, :__corresponding_view_binding__

  # Constraints
  # -----------
  #
  # Indented listings are sub-constraints from general constraint they are indented below
  # 
  attr_configuration        :required?                    => :__required__=, 
                            :multiple_values_permitted?   => :__multiple_values_permitted__=, 
                            :object_permitted?            => :__object_permitted__=,
                                :view_permitted?          => :__view_permitted__=, 
                                :text_permitted?          => :__text_permitted__=, 
                                :number_permitted?        => :__number_permitted__=, 
                                    :integer_permitted?   => :__integer_permitted__=, 
                                    :float_permitted?     => :__float_permitted__=,
                                    :complex_permitted?   => :__complex_permitted__=,
                                    :rational_permitted?  => :__rational_permitted__=, 
                                :module_permitted?        => :__module_permitted__=, 
                                :class_permitted?         => :__class_permitted__=, 
                                :true_false_permitted?    => :__true_false_permitted__=,
                                :regexp_permitted?        => :__regexp_permitted__=, 
                                :file_permitted?          => :__file_permitted__=
                              
  # Configuration
  # -------------
  #
  attr_configuration_array  :__configuration_procs__, :__validation_procs__
  
  # Instance-Specific Elements
  # --------------------------
  #
  attr_accessor             :__route__
  attr_reader               :__bound_module__, :__sub_bindings__, :__shared_sub_bindings__
  
  ################
  #  initialize  #
  ################

  def initialize( bound_module, 
                  binding_name, 
                  view_class = nil, 
                  ancestor_binding = nil,
                  base_route = nil, 
                  & configuration_proc )
    
    self.__name__ = binding_name
    
    @__bound_module__ = bound_module
    @__route__ = base_route
    
    initialize_for_ancestor( ancestor_binding )
    
    initialize_sub_bindings_for_view_class( view_class )
        
    if block_given?
      configure( & configuration_proc )
    end
        
  end

  #############################
  #  initialize_for_ancestor  #
  #############################
  
  def initialize_for_ancestor( ancestor_binding )
    
    binding_name = __name__
    
    # To set up cascading configurations we need to register our parent/child inheritance tree.
    # We already have this set up in parallel by way of the bound instances.
    # So we need to see if our bound instance has an ancestor; if it does, get our parallel
    # binding of the same name and register it as parent of self.
    ccv = ::CascadingConfiguration::Variable
    
    ccv.register_configuration( self, binding_name )
    
    if ancestor_binding

      ::CascadingConfiguration::Ancestors.register_child_for_parent( self, ancestor_binding )
      
    elsif binding_ancestor = ccv.ancestor_for_registered_instance( @__bound_module__, binding_name )

      ccv.register_configuration( @__bound_module__, binding_name )

      ancestor_binding = binding_ancestor.binding_configuration( binding_name )

      ::CascadingConfiguration::Ancestors.register_child_for_parent( self, ancestor_binding )

    else
      
      ccv.register_configuration( @__bound_module__, binding_name )

      initialize_default_values

    end

  end
  
  ###############################
  #  initialize_default_values  #
  ###############################
  
  def initialize_default_values

    self.__required__                  = false
    self.__multiple_values_permitted__ = false
    self.__text_permitted__            = false
    self.__number_permitted__          = false
    self.__integer_permitted__         = false
    self.__float_permitted__           = false
    self.__complex_permitted__         = false
    self.__rational_permitted__        = false
    self.__regexp_permitted__          = false
    self.__module_permitted__          = false
    self.__class_permitted__           = false
    self.__true_false_permitted__      = false
    self.__file_permitted__            = false
    self.__view_permitted__            = false
    self.__object_permitted__          = false
    
  end
  
  ############################################
  #  initialize_sub_bindings_for_view_class  #
  ############################################
  
  def initialize_sub_bindings_for_view_class( view_class = nil )
    
    @__sub_bindings__ ||= { }
    @__sub_bindings__.clear
    @__shared_sub_bindings__ ||= { }
    @__shared_sub_bindings__.clear
		
    # Define a method for each binding defined in default view for this binding.
    # 
	  # Obviously, we can only do this if we have a default view class.
	  # 
	  # If we have a default view class defined and are later assigned a view instance, then the 
	  # instance is expected to respond to any methods that have values defined in the enclosing view.
	  # In other words, if we have class Document containing HTML, which has Head and Body, and if
	  # Document.Title = Document.HTML.Title, then if instance document.title is set to 'title'
	  # we expect instance document to answer to :html and the result to answer to :title=, 
	  # or in other words: document.html.title = 'title'.
	  #
    if self.__view_class__ = view_class
  	  
  		unless view_class.respond_to?( :binding_configurations )
    		raise ::Rmagnets::Bindings::Exception::ViewClassLacksBindings,
    		        'Class ' + view_class.to_s + ' was declared as a view class, ' +
    		        'but does not respond to :' + :binding_configurations.to_s + '.'
		  end

      base_route = nil
  		if @__route__
  		  base_route = @__route__.dup
		  else
  		  base_route = [ ]
  		end
  		base_route.push( __name__ )

  		view_class.binding_configurations.each do |this_binding_name, this_binding_instance|
  
        this_sub_binding = this_binding_instance.duplicate_as_inheriting_sub_binding( base_route )

        @__sub_bindings__[ this_binding_name ] = this_sub_binding

        #====================#
        #  sub_binding_name  #
        #====================#

        define_singleton_method( this_binding_name ) do

    	    return @__sub_bindings__[ this_binding_name ]

        end
        
  	  end
		
  		view_class.shared_binding_configurations.each do |this_binding_name, this_binding_instance|
  
        this_shared_binding_instance = nil

        if this_shared_binding_route = this_binding_instance.__route__
          # with shared bindings, instead of duplicating the binding we want to get
          # the equivalent binding that we have already duplicated from binding_configurations
          this_shared_binding_name = this_binding_instance.__name__
          this_shared_binding_instance = shared_binding_for_route( this_shared_binding_route, 
                                                                   this_shared_binding_name )
        end

        @__shared_sub_bindings__[ this_binding_name ] = this_shared_binding_instance

        #===========================#
        #  shared_sub_binding_name  #
        #===========================#

        define_singleton_method( this_binding_name ) do

    	    return @__shared_sub_bindings__[ this_binding_name ]

        end
        
  	  end
	  
	  end
  	  		  
  end
    
  ##############################
  #  shared_binding_for_route  #
  ##############################
  
  def shared_binding_for_route( binding_route, shared_binding_name )
    
    shared_binding_context = self.class.shared_binding_context( shared_binding_name,
                                                                self,
                                                                binding_route,
                                                                shared_binding_name )
    
    return shared_binding_context.__send__( shared_binding_name )
    
  end

  #########################################
  #  duplicate_as_inheriting_sub_binding  #
  #########################################

  def duplicate_as_inheriting_sub_binding( base_route = @__route__ )
    
    return self.class.new( @__bound_module__, __name__, __view_class__, self, base_route )
    
  end
  
	###################################  Runtime Configuration  ######################################
  
  ###############
  #  configure  #
  ###############

  def configure( & configuration_proc )
        
    __configuration_procs__.push( configuration_proc )
    
  end

  ##############
  #  validate  #
  ##############

  def validate( & validation_proc )

    __validation_procs__.push( validation_proc )

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
                  'binding configuration for binding :' + __name__.to_s
        end
        
        binding_value.each do |this_binding_value|
          ensure_binding_value_valid( this_binding_value )
        end
      
      when String, Symbol

        unless object_permitted? or text_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'String given ("' + binding_value.inspect.to_s + '") but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
        
      when Integer
        
        unless object_permitted? or number_permitted? or integer_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Integer given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
        
      when Float
      
        unless object_permitted? or number_permitted? or float_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Float given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
      
      when Complex
        
        unless object_permitted? or number_permitted? or complex_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Complex given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
        
      when Rational

        unless object_permitted? or number_permitted? or rational_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Rational given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
        
      when Regexp
        
        unless object_permitted? or regexp_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Regexp given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
        
      when Class

        unless object_permitted? or module_permitted? or class_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Regexp given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
        
      when Module

        unless object_permitted? or module_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'Regexp given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
        
      when TrueClass, FalseClass

        unless object_permitted? or true_false_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'True/False given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
        
      when File
        
        unless object_permitted? or file_permitted?
          raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError
                  'File given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                  'binding configuration for binding :' + __name__.to_s
        end
        
      else

        if binding_value.respond_to?( :to_html_node )     or 
           binding_value.respond_to?( :to_html_fragment )

          unless object_permitted? or view_permitted?
            raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError,
                    'View given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                    'binding configuration for binding :' + __name__.to_s
          end
          
        else
        
          unless object_permitted?
            raise ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError,
                    'Object given (' + binding_value.inspect.to_s + ') but prohibited by ' +
                    'binding configuration for binding :' + __name__.to_s
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
			        'Binding :' + __name__.to_s + ' is required but not bound for binding :' + 
			        __name__.to_s + ' (' + @__bound_module__.to_s + ').'

		end
		
		__validation_procs__.each do |this_validation_proc|
  	  case this_validation_proc.arity
        when 1
    		  this_validation_proc.call( binding_value )
        else
    		  this_validation_proc.call( self, binding_value )
  	  end
    end
		
	end
	
	##########################
	#  render_binding_value  #
	##########################
	
	def render_binding_value( binding_value )
	  
	  rendered_binding_value = nil
	  
	  case binding_value
      
      when nil
      
        # nothing required
      
      when String

        rendered_binding_value = binding_value
        
      when Symbol, Integer, Float, Complex, Rational, Regexp, Class, Module, TrueClass, FalseClass

        rendered_binding_value = binding_value.to_s
        
      when File
        
        rendered_binding_value = File.readlines.join
        
      else
        
        rendered_binding_value = binding_value
        
    end
    
    return rendered_binding_value
    
  end
	
	#########################################  Options  ##############################################
	
  ###############
  #  optional?  #
  ###############
  
  def optional?

    return ! required?

  end
  
end
