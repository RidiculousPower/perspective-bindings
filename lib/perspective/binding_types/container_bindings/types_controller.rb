# -*- encoding : utf-8 -*-

class ::Perspective::BindingTypes::ContainerBindings::TypesController

  #############################
  #  self.new_class_bindings  #
  #############################
  
  ###
  # Can be overridden in BindingType modules.
  #
  def self.new_class_bindings( binding_type, bound_to_container, *binding_descriptors, & configuration_proc )

    class_binding_class = binding_type.class_binding_class

    return parse_binding_declaration_args( *binding_descriptors ).collect do |this_binding_name, this_container_class|
      class_binding_class.new( bound_to_container, this_binding_name, this_container_class, & configuration_proc )
    end
    
  end

  #########################################
  #  self.parse_binding_declaration_args  #
  #########################################

  # :binding_name, ...
  # :binding_name, container_class, ...
  # :binding_name => container_class, ...
  # :binding_name1, :binding_name2 => container_class
	def self.parse_binding_declaration_args( *args )
    
    # return format: { :binding_name => container_class, ... }
	  binding_descriptions = { }
    
	  until args.empty?
      
      case next_arg = args.shift
        
        when ::Hash
          
          # Hash without having parsed other names - each pair is a declaration:
          # 
          #   :name1 => container_class1, :name2 => container_class2
          #
          # Produces:
          # 
          # * binding_name1 with container_class1
          # * binding_name2 with container_class2
          # 
          binding_descriptions.merge!( next_arg )
        
        when ::Symbol, ::String
        
          binding_names = [ next_arg ]
        
          container_class = nil
          remaining_hash_declarations = nil
          
          until args.empty?
          
            case next_arg = args.shift
            
              when ::Hash
            
                # Hash after having parsed other names - each pair is a declaration,
                # but first pair also applies to all binding names collected:
                #
                #   :name1, :name2, :name3 => container_class1, :name4 => container_class2
                # 
                # Produces: 
                # 
                # * binding_name1, binding_name2, binding_name3 with container_class1
                # * binding_name4 with container_class2
                # 
                
                # save the first pair to process after
                first_pair = next_arg.shift
                binding_names.push( first_pair[ 0 ] )
                container_class = first_pair[ 1 ]
                
                unless next_arg.empty?
                  remaining_hash_declarations = next_arg
                end

                break
            
              when ::Symbol, ::String
            
                binding_names.push( next_arg )
            
              else
            
                container_class = next_arg                
                break
            
            end
          
          end
          
          binding_names.each do |this_binding_name|
            binding_descriptions[ this_binding_name ] = container_class
          end
          
          if remaining_hash_declarations
            binding_descriptions.merge!( remaining_hash_declarations )
          end
                
        else
        
          raise ::ArgumentError, 'Got Container argument without binding name.'
        
      end
    
    end
    
    return binding_descriptions
    
  end
  
end
