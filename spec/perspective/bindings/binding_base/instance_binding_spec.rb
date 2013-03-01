# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'

require_relative 'instance_binding.rb'

describe ::Perspective::Bindings::BindingBase::InstanceBinding do

  it_behaves_like :base_instance_binding do

    setup_instance_binding_tests

    let( :class_binding_class ) { ::Class.new { include( ::Perspective::Bindings::BindingBase::ClassBinding ) } }

    let( :instance_binding_class ) do
      ::Class.new do
        include( ::Perspective::Bindings::BindingBase::InstanceBinding )
      end
    end

  end
  
end
