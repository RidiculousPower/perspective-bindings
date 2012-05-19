
module ::Magnets::Binding::ParseBindingDeclarationArgs

  ####################################
  #  parse_binding_declaration_args  #
  ####################################

  # :binding_name, ...
  # :binding_name, view_class, ...
  # :binding_name => view_class, ...
  # :binding_name1, :binding_name2 => view_class
	def parse_binding_declaration_args( *args )
    
    # return format: { :binding_name => view_class, ... }
	  binding_descriptions = { }
    
	  until args.empty?
      
      next_arg = args.shift
      
      case next_arg
        
        when ::Hash
          
          # Hash without having parsed other names - each pair is a declaration:
          # 
          #   :name1 => view_class1, :name2 => view_class2
          #
          # Produces:
          # 
          # * binding_name1 with view_class1
          # * binding_name2 with view_class2
          # 
          binding_descriptions.merge!( next_arg )
        
        when ::Symbol, ::String
        
          binding_names = [ next_arg ]
        
          view_class = nil
        
          remaining_hash_declarations = nil
          
          until args.empty?
          
            next_arg = args.shift
          
            case next_arg
            
              when ::Hash
            
                # Hash after having parsed other names - each pair is a declaration,
                # but first pair also applies to all binding names collected:
                #
                #   :name1, :name2, :name3 => view_class1, :name4 => view_class2
                # 
                # Produces: 
                # 
                # * binding_name1, binding_name2, binding_name3 with view_class1
                # * binding_name4 with view_class2
                # 
                
                # save the first pair to process after
                first_pair = next_arg.shift
                binding_names.push( first_pair[ 0 ] )
                view_class = first_pair[ 1 ]
                
                unless next_arg.empty?
                  remaining_hash_declarations = next_arg
                end

                break
            
              when ::Symbol, ::String
            
                binding_names.push( next_arg )
            
              else
            
                view_class = next_arg                
                break
            
            end
          
          end
          
          binding_names.each do |this_binding_name|
            binding_descriptions[ this_binding_name ] = view_class
          end
          
          if remaining_hash_declarations
            binding_descriptions.merge!( remaining_hash_declarations )
          end
                
        else
        
          raise ::ArgumentError, 'Got View argument without binding name.'
        
      end
    
    end
    
    return binding_descriptions
    
  end
  
end
