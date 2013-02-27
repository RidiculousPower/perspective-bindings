
#################
#  match_types  #
#################

RSpec::Matchers.define :match_types do |*match_types|

  fail_string = nil
  unexpected_success_string = nil

  match do |binding_definition_instance|

    unexpected_success_string = 'match types :' << match_types.join( ', :' ) << 
                                ' matched but were not expected to do so.'

    matched = nil
    
    # :class
    if match_types.include?( :class )
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( Object )
        fail_string = 'Match types included :class but ' << Object.to_s << ' reported not valid.'
      end
    end
    
    # :module
    if match_types.include?( :module )
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( Kernel )
        fail_string = 'Match types included :module but ' << Kernel.to_s << ' reported not valid.'
      end
    end
    
    # :file
    if match_types.include?( :file )
      file = File.new( __FILE__ )
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( file )
        fail_string = 'Match types included :file but ' << file.to_s << ' reported not valid.'
      end
    end
    
    # :integer
    if match_types.include?( :integer )
      integer = 42
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( integer )
        fail_string = 'Match types included :integer but ' << integer.to_s << ' reported not valid.'
      end
    end
    
    # :float
    if match_types.include?( :float )
      float = 42.0
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( float )
        fail_string = 'Match types included :float but ' << float.to_s << ' reported not valid.'
      end
    end
    
    # :complex
    if match_types.include?( :complex )
      complex = Complex( 1, 2 )
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( complex )
        fail_string = 'Match types included :complex but ' << complex.to_s << ' reported not valid.'
      end
    end
    
    # :rational
    if match_types.include?( :rational )
      rational = Rational( 1, 2 )
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( rational )
        fail_string = 'Match types included :rational but ' << rational.to_s << ' reported not valid.'
      end
    end
    
    # :regexp
    if match_types.include?( :regexp )
      regexp = /some_regexp/
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( regexp )
        fail_string = 'Match types included :regexp but ' << regexp.to_s << ' reported not valid.'
      end
    end
    
    # :text    
    if match_types.include?( :text )
      string_text = 'string'
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( string_text )
        fail_string = 'Match types included :text but ' << string_text.to_s << ' reported not valid.'
      end
    end
    
    if match_types.include?( :text )
      symbol_text = :symbol
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( symbol_text )
        fail_string = 'Match types included :text but ' << symbol_text.to_s << ' reported not valid.'
      end
    end
    
    
    # :true_or_false
    if match_types.include?( :true_or_false )
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( true )
        fail_string = 'Match types included :true_or_false but ' << true.to_s << ' reported not valid.'
      end
    end
    
    if match_types.include?( :true_or_false )
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( false )
        fail_string = 'Match types included :true_or_false but ' << false.to_s << ' reported not valid.'
      end
    end
    
    # :uri
    if match_types.include?( :uri ) or match_types.include?( :text )
      uri_string = 'http://some.uri'
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( uri_string )
        fail_string = 'Match types included :uri but ' << uri_string.to_s << ' reported not valid.'
      end
    end
    
    if match_types.include?( :uri )
      uri_object = URI.parse( 'http://some.uri' )
      unless fail_string or matched = binding_definition_instance.__binding_value_valid__?( uri_object )
        fail_string = 'Match types included :uri but ' << uri_object.to_s << ' reported not valid.'
      end
    end
    
    matched
    
  end

  failure_message_for_should { fail_string }
  failure_message_for_should_not { unexpected_success_string }

end
