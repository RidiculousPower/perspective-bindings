
require_relative '../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::ParseBindingDeclarationArgs do
  
  it 'can parse arguments for creating bindings' do
    
    # :binding_name, ...
    # :binding_name, container_class, ...
    # :binding_name => container_class, ...
    # :binding_name1, :binding_name2 => container_class
    
    module ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock
      extend ::Perspective::Bindings::ParseBindingDeclarationArgs
      class Container1
      end
      class Container2
      end
      class Container3
      end
    end
    
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, :binding_two, :binding_three )
    result.should == { :binding_one => nil, :binding_two => nil, :binding_three => nil }
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1 )
    result.should == { :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1 }
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                                                                                                    :binding_two => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2, 
                                                                                                    :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container3 )
    result.should == { :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_two => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2, 
                       :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container3 }
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, 
                                                                                                    :binding_two, 
                                                                                                    :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1 )
    result.should == { :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_two => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1 }
    
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, 
                                                                                                    :binding_two, 
                                                                                                    :binding_three, 
                                                                                                    :binding_four, ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1,
                                                                                                    :binding_five, { 
                                                                                                    :binding_six => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2,
                                                                                                    :binding_seven => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container3 },
                                                                                                    :binding_eight )
    result.should == { :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_two => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1,
                       :binding_four => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1,
                       :binding_five => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2,
                       :binding_six => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2,
                       :binding_seven => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container3,
                       :binding_eight => nil }
    
  end
  
end
