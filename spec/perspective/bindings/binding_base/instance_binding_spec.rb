
require_relative '../../../../lib/perspective/bindings.rb'

require_relative 'instance_binding.rb'

describe ::Perspective::Bindings::BindingBase::InstanceBinding do

  it_behaves_like :instance_binding do

    let( :class_binding_class ) { ::Class.new { include( ::Perspective::Bindings::BindingBase::ClassBinding ) } }

    let( :instance_binding_class ) do
      ::Class.new do
        include( ::Perspective::Bindings::BindingBase::InstanceBinding )
        alias_method( :__extend__, :extend )
      end
    end

  end
  
end
