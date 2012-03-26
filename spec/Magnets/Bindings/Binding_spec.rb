
require_relative '../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::Binding do

  ##################
  #  initialize    #
  #  required?     #
  #  optional?     #
  #  required=     #
  ##################

  it 'can initialize and report configuration in a hierarchical fashion' do
    
    # we need to mock 3 levels of views
    
    # View A has a binding B of View B and a binding C to C in binding B of View C    

    class ::Rmagnets::Bindings::Binding::MockViewC
      @binding_instance = ::Rmagnets::Bindings::Binding.new( self, :binding_instance )
      def self.binding_configurations
        return { :binding_instance => @binding_instance }
      end
      def self.shared_binding_configurations
        return { }
      end
    end
    
    class ::Rmagnets::Bindings::Binding::MockViewB
      @binding_c = ::Rmagnets::Bindings::Binding.new( self,
                                                      :binding_C,
                                                      ::Rmagnets::Bindings::Binding::MockViewC )
      @binding_instance = ::Rmagnets::Bindings::Binding.new( self, :binding_instance )
      def self.binding_configurations
        return { :binding_C => @binding_c,
                 :binding_instance => @binding_instance }
      end
      def self.shared_binding_configurations
        return { }
      end
    end
    
    class ::Rmagnets::Bindings::Binding::MockViewA
      @binding_b = ::Rmagnets::Bindings::Binding.new( self,
                                                      :binding_B,
                                                      ::Rmagnets::Bindings::Binding::MockViewB )
      @binding_instance = ::Rmagnets::Bindings::Binding.new( self, :binding_instance )
      def self.binding_configurations
        return { :binding_B => @binding_b,
                 :binding_instance => @binding_instance }
      end
      def self.shared_binding_configurations
        return { }
      end
    end

    ::Rmagnets::Bindings::Binding::MockViewA.instance_eval do
      
      @binding_b.respond_to?( :binding_C ).should == true
      
      @binding_b.binding_C.should_not == nil
      
      @binding_b.binding_C.should_not == ::Rmagnets::Bindings::Binding::MockViewB.instance_variable_get( :@binding_c )
      
      ::CascadingConfiguration::Variable.ancestor( @binding_b.binding_C, :__name__ ).should == ::Rmagnets::Bindings::Binding::MockViewB.instance_variable_get( :@binding_c )
      ::CascadingConfiguration::Variable.ancestor( @binding_b.binding_C, :required? ).should == ::Rmagnets::Bindings::Binding::MockViewB.instance_variable_get( :@binding_c )
      
      @binding_b.required?.should == false
      @binding_b.optional?.should == true
      
      ::Rmagnets::Bindings::Binding::MockViewB.instance_variable_get( :@binding_c ).__required__ = true      

      @binding_b.binding_C.required?.should == true
      @binding_b.binding_C.optional?.should == false

    end
    
  end
      
end
