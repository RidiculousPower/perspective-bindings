
require_relative '../../../../lib/perspective/bindings.rb'

require_relative 'class_binding.rb'

describe ::Perspective::Bindings::BindingBase::ClassBinding do
  
  setup_base_class_binding_tests
  
  it_behaves_like :base_class_binding do
    let( :class_binding_class ) { ::Class.new { include( ::Perspective::Bindings::BindingBase::ClassBinding ) } }
  end
  
end
