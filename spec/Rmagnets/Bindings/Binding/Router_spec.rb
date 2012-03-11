
require_relative '../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::Binding::Router do

  ################
  #  initialize  #
  ################
  
  it 'can be initialized for a binding instance' do
    
    class ::Rmagnets::Bindings::Binding::Mock
      include ::CascadingConfiguration::Array
      class << self
        attr_accessor :binding_instance
      end
      class View
        class OtherView
          class MockBinding
            def name
              return :yet_another_binding
            end
          end
          def self.shared_binding_routers
            return []
          end
          def self.binding_router( binding_name, path )
            return ::Rmagnets::Bindings::Binding::Router.new( ::Rmagnets::Bindings::Binding.new( self,
                                                                                                 :yet_another_binding,
                                                                                                 nil ) )
          end
          def self.binding_routers
            return { :yet_another_binding => MockBinding.new }
          end
          def self.binding_configurations
            return binding_routers
          end
        end
        class MockBinding
          def name
            return :some_other_binding
          end
        end
        def self.binding_router( binding_name, path )
          return ::Rmagnets::Bindings::Binding::Router.new( ::Rmagnets::Bindings::Binding.new( self,
                                                                                               :some_other_binding,
                                                                                               ::Rmagnets::Bindings::Binding::Mock::View::OtherView ) )
        end
        def self.shared_binding_routers
          return []
        end
        def self.binding_configurations
          return binding_routers
        end
        def self.binding_routers
          return { :some_other_binding => MockBinding.new }
        end
      end
      # mock
      def self.binding_configuration( name )
        return @binding_instance
      end
      def self.binding_configurations
        return binding_routers
      end
      def self.binding_routers
        return { :some_binding => View::OtherView::MockBinding.new }
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

    binding_router = ::Rmagnets::Bindings::Binding::Router.new( first_binding )
    binding_router.__binding_instance__.should == first_binding
    binding_router.respond_to?( :some_other_binding ).should == true
    binding_router.some_other_binding.is_a?( ::Rmagnets::Bindings::Binding::Router ).should == true
        
  end

end
