
require_relative '../../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance::Methods::SharedBinding do

  before :all do
    class ::Magnets::Binding::Container::ClassInstance::Methods::SharedBinding::Mock
      extend ::Magnets::Binding::Container::ClassInstance::Methods::Binding
      extend ::Magnets::Binding::Container::ClassInstance::Methods::SharedBinding
      class BindingViewMock
        def self.__binding_configuration__( binding_name )
          return @config ||= ::Magnets::Binding.new( self,
                                                                :binding_target,
                                                                nil )
        end
        def self.__bindings__
          return { :binding_target => __binding_configuration__( :binding_name ) }
        end
        def self.__shared_bindings__
          return { }
        end
        def self.__shared_bindings__
          return { }
        end
        def self.binding_target
          return __binding_configuration__( :binding_target ).__duplicate_as_inheriting_sub_binding__( [ :binding_name ] )
        end
        def binding_target
          @called_binding_target = true
          return @binding_target ||= :no_value
        end
        def binding_target=
          @called_binding_target = true
          return @binding_target ||= some_value
        end
        def __binding_value__( binding_name )
          @called_binding_target = true
          return @binding_target ||= :no_value
        end
        def __set_binding_value__( binding_name, some_value )
          @called_binding_target = true
          return @binding_target ||= some_value
        end
        def called_binding_target
          did_call_binding_target = @called_binding_target
          @called_binding_target = false
          return did_call_binding_target
        end
        attr_reader :to_html_node
      end
      def self.__binding_configuration__( binding_name )
        return @config ||= ::Magnets::Binding.new( self,
                                                              :binding_name,
                                                              ::Magnets::Binding::Container::ClassInstance::Methods::SharedBinding::Mock::BindingViewMock )
      end
      def self.__bindings__
        return { }
      end
      def self.__shared_bindings__
        return { :binding_name => __binding_configuration__( :binding_name ) }
      end
      def self.binding_name
        return __binding_configuration__( :binding_name )
      end
      def __binding_value__( binding_name )
        @called_binding_name = true
        return @binding_name_mock ||= BindingViewMock.new
      end
      def __set_binding_value__( binding_name, some_value )
        @called_binding_name = true
      end
      def binding_name
        @called_binding_name = true
        return @binding_name_mock ||= BindingViewMock.new
      end
      def binding_name=
        @called_binding_name = true
      end
      def called_binding_name
        did_call_binding_name = @called_binding_name
        @called_binding_name = false
        return did_call_binding_name
      end
    end
  end
  
  #########################################
  #  declare_class_shared_binding_getter  #
  #########################################
  
  it 'can declare a shared binding getter class method' do
    class ::Magnets::Binding::Container::ClassInstance::Methods::SharedBinding::Mock
      declare_class_shared_binding_getter( :binding_alias )
      respond_to?( :binding_alias ).should == true
      binding_alias.should == __shared_bindings__[ :binding_alias ]
    end
  end
  
	###################################
  #  declare_shared_binding_setter  #
  ###################################

  it 'can declare a shared binding setter instance method' do
    class ::Magnets::Binding::Container::ClassInstance::Methods::SharedBinding::Mock
      declare_shared_binding_setter( :binding_alias, binding_name.binding_target )
      method_defined?( :binding_alias= ).should == true
    end
    ::Magnets::Binding::Container::ClassInstance::Methods::SharedBinding::Mock.new.instance_eval do
      self.binding_alias = :blah
      self.binding_name.called_binding_target.should == true
      binding_name.binding_target.should == :blah
    end
  end
  
	###################################
  #  declare_shared_binding_getter  #
  ###################################

  it 'can declare a shared binding getter instance method' do
    class ::Magnets::Binding::Container::ClassInstance::Methods::SharedBinding::Mock
      declare_shared_binding_getter( :binding_alias, binding_name.binding_target )
      method_defined?( :binding_alias ).should == true
    end
    ::Magnets::Binding::Container::ClassInstance::Methods::SharedBinding::Mock.new.instance_eval do
      binding_alias.should == :no_value
      binding_name.called_binding_target.should == true
    end
  end
  
end
