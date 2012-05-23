
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ParseBindingDeclarationArgs do
  
  it 'can parse arguments for creating bindings' do
    
    # :binding_name, ...
    # :binding_name, container_class, ...
    # :binding_name => container_class, ...
    # :binding_name1, :binding_name2 => container_class
    
    module ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock
      extend ::Magnets::Bindings::ParseBindingDeclarationArgs
      class Container1
      end
      class Container2
      end
      class Container3
      end
    end
    
    result = ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, :binding_two, :binding_three )
    result.should == { :binding_one => nil, :binding_two => nil, :binding_three => nil }
    result = ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1 )
    result.should == { :binding_one => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1 }
    result = ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                                                                                                    :binding_two => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container2, 
                                                                                                    :binding_three => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container3 )
    result.should == { :binding_one => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_two => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container2, 
                       :binding_three => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container3 }
    result = ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, 
                                                                                                    :binding_two, 
                                                                                                    :binding_three => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1 )
    result.should == { :binding_one => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_two => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_three => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1 }
    
    result = ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, 
                                                                                                    :binding_two, 
                                                                                                    :binding_three, 
                                                                                                    :binding_four, ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1,
                                                                                                    :binding_five, { 
                                                                                                    :binding_six => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container2,
                                                                                                    :binding_seven => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container3 },
                                                                                                    :binding_eight )
    result.should == { :binding_one => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_two => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_three => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1,
                       :binding_four => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container1,
                       :binding_five => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container2,
                       :binding_six => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container2,
                       :binding_seven => ::Magnets::Bindings::ParseBindingDeclarationArgs::Mock::Container3,
                       :binding_eight => nil }
    
  end
  
end
