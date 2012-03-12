
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding::Mock
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding
      class BindingViewMock
        def self.binding_configuration( binding_name )
          return @config ||= ::Rmagnets::Bindings::Binding.new( self,
                                                                :binding_target,
                                                                nil )
        end
        def self.binding_configurations
          return { :binding_target => binding_configuration( :binding_name ) }
        end
        def self.binding_routers
          return { :binding_target => binding_router( :binding_target ) }
        end
        def self.shared_binding_routers
          return { }
        end
        def self.binding_router( binding_name )
          return @binding_route_mock ||= ::Rmagnets::Bindings::Binding::Router.new( binding_configuration( :binding_name ) )
        end
        def self.binding_target
          return binding_router( :binding_target ).duplicate_for_shared_router( [ :binding_name ] )
        end
        def binding_target
          @called_binding_target = true
          return @binding_target ||= :no_value
        end
        def binding_target=( some_value )
          @called_binding_target = true
          return @binding_target ||= some_value
        end
        def called_binding_target
          did_call_binding_target = @called_binding_target
          @called_binding_target = false
          return did_call_binding_target
        end
      end
      def self.binding_configuration( binding_name )
        return @config ||= ::Rmagnets::Bindings::Binding.new( self,
                                                              :binding_name,
                                                              ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding::Mock::BindingViewMock )
      end
      def self.binding_router( binding_name )
        @called_binding_router = true
        return @binding_route_mock ||= ::Rmagnets::Bindings::Binding::Router.new( binding_configuration( :binding_name ) )
      end
      def self.called_binding_router
        did_call_binding_router = @called_binding_router
        @called_binding_router = false
        return did_call_binding_router
      end
      def self.binding_name
        return binding_router( :binding_name )
      end
      def binding_name
        @called_binding_name = true
        return @binding_name_mock ||= BindingViewMock.new
      end
      def binding_name=( name )
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
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding::Mock
      declare_class_shared_binding_getter( :binding_alias )
      respond_to?( :binding_alias ).should == true
      binding_alias.should == binding_router( :binding_alias )
      called_binding_router.should == true
      binding_alias.should == binding_router( :binding_alias )
    end
  end
  
	###################################
  #  declare_shared_binding_setter  #
  ###################################

  it 'can declare a shared binding setter instance method' do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding::Mock
      declare_shared_binding_setter( :binding_alias, binding_name.binding_target )
      instance_methods.include?( :binding_alias= ).should == true
    end
    ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding::Mock.new.instance_eval do
      self.binding_alias = :blah
      self.binding_name.called_binding_target.should == true
      self.class.called_binding_router.should == true
      binding_name.binding_target.should == :blah
    end
  end
  
	###################################
  #  declare_shared_binding_getter  #
  ###################################

  it 'can declare a shared binding getter instance method' do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding::Mock
      declare_shared_binding_getter( :binding_alias, binding_name.binding_target )
      instance_methods.include?( :binding_alias ).should == true
    end
    ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding::Mock.new.instance_eval do
      binding_alias.should == :no_value
      binding_name.called_binding_target.should == true
    end
  end
  
end
