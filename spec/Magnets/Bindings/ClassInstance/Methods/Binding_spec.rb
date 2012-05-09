
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock
      class << self
        attr_accessor :binding_instance
      end
      def __set_binding_value__( binding_name, object )
        instance_variable_set( binding_name.variable_name, object )
        return self.class.binding_instance.__ensure_binding_value_valid__( object )
      end
      def __binding_value__( binding_name )
        return instance_variable_get( binding_name.variable_name )
      end
      class InstanceMock
        def __ensure_binding_value_valid__( binding_value )
          @called_ensure_binding_value_valid = true
        end
        def called_ensure_binding_value_valid
          did_call_ensure_binding_value_valid = @called_ensure_binding_value_valid
          @called_ensure_binding_value_valid = false
          return did_call_ensure_binding_value_valid
        end
        def __corresponding_view_binding__
          return nil
        end
      end
      extend ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding
    end
  end
  
  ##################################
  #  declare_class_binding_getter  #
  ##################################
  
  it 'can declare a getter class method' do
    class ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock
      def self.__bindings__
        return { :binding_name => :configuration_binding }
      end
      declare_class_binding_getter( :binding_name )
      respond_to?( :binding_name ).should == true
      binding_name.should == :configuration_binding
    end
  end

  ############################
  #  declare_binding_setter  #
  ############################

  it 'can declare a setter instance method' do
    class ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock
      @binding_instance = ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock::InstanceMock.new
      declare_binding_setter( :binding_name )
      method_defined?( :binding_name= ).should == true
    end
    ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock.new.instance_eval do
      self.binding_name = :value
      self.class.binding_instance.called_ensure_binding_value_valid.should == true
      instance_variable_get( :@binding_name ).should == :value
    end
  end

  ############################
  #  declare_binding_getter  #
  ############################

  it 'can declare a getter instance method' do
    class ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock
      @binding_instance = ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock::InstanceMock.new
      declare_binding_getter( :binding_name )
      method_defined?( :binding_name ).should == true
    end
    ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding::Mock.new.instance_eval do
      instance_variable_set( :@binding_name, :value )
      self.binding_name.should == :value
    end
  end

end
