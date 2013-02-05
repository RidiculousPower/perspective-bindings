
require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::Container::BindingTypeContainerInterface do

  let( :type_container ) { ::Perspective::Bindings::BindingTypes::ContainerBindings }
  let( :binding_type ) { ::Perspective::Bindings::BindingTypes::ContainerBindings::Binding }
  let( :bound_container ) do
    ::Module.new do
      def self.__root__
        return self
      end
      def self.__root_string__
        return @__root_string__ ||= '<root:' << to_s << '>'
      end
    end
  end
  
  ########################
  #  new_class_bindings  #
  ########################
  
  context '#new_class_bindings' do
    it 'creates new class bindings for a container, a list of names, and an optional block' do
      new_bindings = type_container.new_class_bindings( binding_type, bound_container, :some_name, :some_other_name, :another_name )
      new_bindings.each do |this_binding|
        this_binding.is_a?( ::Perspective::Bindings::BindingBase::ClassBinding ).should be true
        this_binding.is_a?( ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBindingBase ).should be true
        this_binding.is_a?( type_container::Binding ).should be true
        this_binding.__bound_container__.should be bound_container
      end
    end
  end
  
end
