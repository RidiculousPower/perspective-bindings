
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Binding do

  ##################
  #  initialize    #
  #  required?     #
  #  optional?     #
  #  required=     #
  ##################

  it 'can initialize and report configuration in a hierarchical fashion' do
    
    # we need to mock 3 levels of views
    
    # View A has a binding B of View B and a binding C to C in binding B of View C    

    class ::Magnets::Bindings::Binding::MockViewC
      @binding_instance = ::Magnets::Bindings::Binding.new( self, :binding_instance )
      def self.__binding_configurations__
        return { :binding_instance => @binding_instance }
      end
      def self.__shared_binding_configurations__
        return { }
      end
    end
    
    class ::Magnets::Bindings::Binding::MockViewB
      @binding_c = ::Magnets::Bindings::Binding.new( self,
                                                      :binding_C,
                                                      ::Magnets::Bindings::Binding::MockViewC )
      @binding_instance = ::Magnets::Bindings::Binding.new( self, :binding_instance )
      def self.__binding_configurations__
        return { :binding_C => @binding_c,
                 :binding_instance => @binding_instance }
      end
      def self.__shared_binding_configurations__
        return { }
      end
    end
    
    class ::Magnets::Bindings::Binding::MockViewA
      @binding_b = ::Magnets::Bindings::Binding.new( self,
                                                      :binding_B,
                                                      ::Magnets::Bindings::Binding::MockViewB )
      @binding_instance = ::Magnets::Bindings::Binding.new( self, :binding_instance )
      def self.__binding_configurations__
        return { :binding_B => @binding_b,
                 :binding_instance => @binding_instance }
      end
      def self.__shared_binding_configurations__
        return { }
      end
    end

    ::Magnets::Bindings::Binding::MockViewA.instance_eval do
      
      @binding_b.respond_to?( :binding_C ).should == true
      
      @binding_b.binding_C.should_not == nil
      
      @binding_b.binding_C.should_not == ::Magnets::Bindings::Binding::MockViewB.instance_variable_get( :@binding_c )
      
      ::CascadingConfiguration::Variable.ancestor( @binding_b.binding_C, :__name__ ).should == ::Magnets::Bindings::Binding::MockViewB.instance_variable_get( :@binding_c )
      ::CascadingConfiguration::Variable.ancestor( @binding_b.binding_C, :required? ).should == ::Magnets::Bindings::Binding::MockViewB.instance_variable_get( :@binding_c )
      
      @binding_b.required?.should == false
      @binding_b.optional?.should == true
      
      ::Magnets::Bindings::Binding::MockViewB.instance_variable_get( :@binding_c ).__required__ = true      

      @binding_b.binding_C.required?.should == true
      @binding_b.binding_C.optional?.should == false

    end
    
  end
      
end
