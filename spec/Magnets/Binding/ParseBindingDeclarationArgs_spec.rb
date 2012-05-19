
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::ParseBindingDeclarationArgs do
  
  it 'can parse arguments for creating bindings' do
    
    # :binding_name, ...
    # :binding_name, view_class, ...
    # :binding_name => view_class, ...
    # :binding_name1, :binding_name2 => view_class
    
    module ::Magnets::Binding::ParseBindingDeclarationArgs::Mock
      extend ::Magnets::Binding::ParseBindingDeclarationArgs
      class View1
      end
      class View2
      end
      class View3
      end
    end
    
    result = ::Magnets::Binding::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, :binding_two, :binding_three )
    result.should == { :binding_one => nil, :binding_two => nil, :binding_three => nil }
    result = ::Magnets::Binding::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1 )
    result.should == { :binding_one => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1 }
    result = ::Magnets::Binding::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1, 
                                                                                                   :binding_two => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View2, 
                                                                                                   :binding_three => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View3 )
    result.should == { :binding_one => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1, 
                       :binding_two => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View2, 
                       :binding_three => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View3 }
    result = ::Magnets::Binding::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, 
                                                                                                   :binding_two, 
                                                                                                   :binding_three => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1 )
    result.should == { :binding_one => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1, 
                       :binding_two => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1, 
                       :binding_three => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1 }
    
    result = ::Magnets::Binding::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, 
                                                                                                   :binding_two, 
                                                                                                   :binding_three, 
                                                                                                   :binding_four, ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1,
                                                                                                   :binding_five, { 
                                                                                                   :binding_six => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View2,
                                                                                                   :binding_seven => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View3 },
                                                                                                   :binding_eight )
    result.should == { :binding_one => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1, 
                       :binding_two => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1, 
                       :binding_three => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1,
                       :binding_four => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View1,
                       :binding_five => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View2,
                       :binding_six => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View2,
                       :binding_seven => ::Magnets::Binding::ParseBindingDeclarationArgs::Mock::View3,
                       :binding_eight => nil }
    
  end
  
end
