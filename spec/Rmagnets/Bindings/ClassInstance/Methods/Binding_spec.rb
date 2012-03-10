
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock
      class << self
        attr_accessor :binding_instance
      end
      class InstanceMock
        def ensure_binding_value_valid( binding_value )
          @called_ensure_binding_value_valid = true
        end
        def called_ensure_binding_value_valid
          did_call_ensure_binding_value_valid = @called_ensure_binding_value_valid
          @called_ensure_binding_value_valid = false
          return did_call_ensure_binding_value_valid
        end
      end
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding
    end
  end
  
  ##################################
  #  declare_class_binding_getter  #
  ##################################
  
  it 'can declare a getter class method' do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock
      def self.binding_router( binding_name )
        return @configuration_route ||= :configuration_route
      end
      declare_class_binding_getter( :binding_name )
      respond_to?( :binding_name ).should == true
      binding_name.should == :configuration_route
    end
  end

  ############################
  #  declare_binding_setter  #
  ############################

  it 'can declare a setter instance method' do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock
      @binding_instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock::InstanceMock.new
      declare_binding_setter( :binding_name, @binding_instance )
      instance_methods.include?( :binding_name= ).should == true
    end
    ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock.new.instance_eval do
      self.binding_name = :value
      self.class.binding_instance.called_ensure_binding_value_valid.should == true
      instance_variable_get( :@binding_name ).should == :value
    end
  end

  ############################
  #  declare_binding_getter  #
  ############################

  it 'can declare a getter instance method' do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock
      @binding_instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock::InstanceMock.new
      declare_binding_getter( :binding_name, @binding_instance )
      instance_methods.include?( :binding_name ).should == true
    end
    ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock.new.instance_eval do
      instance_variable_set( :@binding_name, :value )
      self.binding_name.should == :value
    end
  end

end
