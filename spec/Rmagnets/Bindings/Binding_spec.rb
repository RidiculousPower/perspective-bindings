
require_relative '../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::Binding do

  ##################
  #  initialize    #
  #  required?     #
  #  optional?     #
  #  required=     #
  ##################

  it 'can initialize and report configuration in a hierarchical fashion' do
    class ::Rmagnets::Bindings::Binding::Mock
      include ::CascadingConfiguration::Array
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance
      class << self
        attr_accessor :binding_instance
      end
      class View
      end
      # mock
      def self.binding_configuration( name )
        return @binding_instance
      end
      def self.some_binding
      end
    end
    class ::Rmagnets::Bindings::Binding::MockSub < ::Rmagnets::Bindings::Binding::Mock
      class View
      end
    end
    configuration_instance = ::Rmagnets::Bindings::Binding::Mock
    configuration_proc = Proc.new { puts 'something' }
    first_binding = ::Rmagnets::Bindings::Binding.new( configuration_instance,
                                                       :some_binding,
                                                       ::Rmagnets::Bindings::Binding::Mock::View,
                                                       & configuration_proc )
    configuration_instance.binding_instance = first_binding
    first_binding.required?.should == false
    first_binding.optional?.should == true
    first_binding.required = true
    first_binding.required?.should == true
    first_binding.optional?.should == false
    first_binding.required = false
    first_binding.required?.should == false
    first_binding.optional?.should == true
    first_binding.required = true
    first_binding.required?.should == true
    first_binding.optional?.should == false
    first_binding.required = false
    first_binding.required?.should == false
    first_binding.optional?.should == true
    first_binding.view_class.should == ::Rmagnets::Bindings::Binding::Mock::View
    first_binding.configuration_procs[0].should == configuration_proc

    sub_configuration_instance = ::Rmagnets::Bindings::Binding::MockSub
    second_binding = ::Rmagnets::Bindings::Binding.new( sub_configuration_instance, :some_binding )
    sub_configuration_instance.binding_instance = second_binding
    sub_configuration_proc = Proc.new { puts 'something' }
    second_binding.required?.should == false
    second_binding.optional?.should == true
    second_binding.view_class.should == ::Rmagnets::Bindings::Binding::Mock::View
    second_binding.configuration_procs[0].should == configuration_proc
    second_binding.configuration_procs.push( sub_configuration_proc )
    second_binding.configuration_procs.should == [ configuration_proc, sub_configuration_proc ]
    first_binding.configuration_procs.should == [ configuration_proc ]
    second_binding.view_class = ::Rmagnets::Bindings::Binding::MockSub::View
    second_binding.view_class.should == ::Rmagnets::Bindings::Binding::MockSub::View
    first_binding.view_class.should == ::Rmagnets::Bindings::Binding::Mock::View
    second_binding.required = true
    second_binding.required?.should == true
    first_binding.required?.should == false
  end
  
end
