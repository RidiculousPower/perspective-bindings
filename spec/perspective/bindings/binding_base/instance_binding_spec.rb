# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'

require_relative 'instance_binding.rb'

describe ::Perspective::Bindings::InstanceBinding do

  it_behaves_like :base_instance_binding do

    setup_instance_binding_tests

    let( :class_binding_class ) { ::Class.new( ::Perspective::Bindings::BindingTypeContainer::BindingType::ClassBindingClass ) { include( ::Perspective::Bindings::ClassBinding ) } }
    let( :instance_binding_class ) { ::Class.new { include( ::Perspective::Bindings::InstanceBinding ) } }

  end
  
end
