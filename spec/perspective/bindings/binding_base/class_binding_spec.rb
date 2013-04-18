# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'

require_relative 'class_binding.rb'

describe ::Perspective::Bindings::ClassBinding do
  
  setup_base_class_binding_tests
  
  it_behaves_like :base_class_binding do
    let( :class_binding_class ) { ::Class.new( ::Perspective::Bindings::BindingTypeContainer::BindingType::ClassBindingClass ) { include( ::Perspective::Bindings::ClassBinding ) } }
  end
  
end
