
require_relative '../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings do
  
  it 'can cascade definitions' do

    class ::Perspective::Bindings::MockNestedE
      include ::Perspective::Bindings
      attr_text :text1, :text2
    end

    ::Perspective::Bindings::MockNestedE.module_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      __binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __route__.should == nil
      __binding__( :text1 ).__route__.should == nil
      __binding__( :text2 ).__route__.should == nil
    end
    ::Perspective::Bindings::MockNestedE.new.instance_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      __binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __route__.should == nil
      __binding__( :text1 ).__route__.should == nil
      __binding__( :text2 ).__route__.should == nil
    end

    class ::Perspective::Bindings::MockNestedD
      include ::Perspective::Bindings
      attr_text :text1, :text2
    end

    ::Perspective::Bindings::MockNestedD.module_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      __binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __route__.should == nil
      __binding__( :text1 ).__route__.should == nil
      __binding__( :text2 ).__route__.should == nil
    end
    ::Perspective::Bindings::MockNestedD.new.instance_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      __binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __route__.should == nil
      __binding__( :text1 ).__route__.should == nil
      __binding__( :text2 ).__route__.should == nil
    end

    class ::Perspective::Bindings::MockNestedC2
      include ::Perspective::Bindings
      attr_binding :e, ::Perspective::Bindings::MockNestedE
    end

    ::Perspective::Bindings::MockNestedC2.module_eval do
      has_binding?( :e ).should == true
      __binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :e ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :e ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :e ).__route__.should == nil
      __binding__( :e ).__binding__( :text1 ).__route__.should == [ :e ]
      __binding__( :e ).__binding__( :text2 ).__route__.should == [ :e ]
    end
    ::Perspective::Bindings::MockNestedC2.new.instance_eval do
      has_binding?( :e ).should == true
      __binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :e ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :e ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      binding_e = __binding__( :e )
      binding_e.__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      __binding__( :e ).__route__.should == nil
      __binding__( :e ).__binding__( :text1 ).__route__.should == [ :e ]
      __binding__( :e ).__binding__( :text2 ).__route__.should == [ :e ]
    end
    
    class ::Perspective::Bindings::MockNestedC1
      include ::Perspective::Bindings
      attr_binding :d, ::Perspective::Bindings::MockNestedD
    end

    ::Perspective::Bindings::MockNestedC1.module_eval do
      has_binding?( :d ).should == true
      __binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :d ).__route__.should == nil
      __binding__( :d ).__binding__( :text1 ).__route__.should == [ :d ]
      __binding__( :d ).__binding__( :text2 ).__route__.should == [ :d ]
    end
    ::Perspective::Bindings::MockNestedC1.new.instance_eval do
      has_binding?( :d ).should == true
      __binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :d ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :d ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      __binding__( :d ).__route__.should == nil
      __binding__( :d ).__binding__( :text1 ).__route__.should == [ :d ]
      __binding__( :d ).__binding__( :text2 ).__route__.should == [ :d ]
    end

    class ::Perspective::Bindings::MockNestedB
      include ::Perspective::Bindings
      attr_binding :c1, ::Perspective::Bindings::MockNestedC1
      attr_binding :c2, ::Perspective::Bindings::MockNestedC2
    end

    ::Perspective::Bindings::MockNestedB.module_eval do
      has_binding?( :c1 ).should == true
      has_binding?( :c2 ).should == true
      __binding__( :c1 ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :c1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :c2 ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :c2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :c1 ).__route__.should == nil
      __binding__( :c1 ).__binding__( :d ).__route__.should == [ :c1 ]
      __binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :c1, :d ]
      __binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :c1, :d ]
      __binding__( :c2 ).__route__.should == nil
      __binding__( :c2 ).__binding__( :e ).__route__.should == [ :c2 ]
      __binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :c2, :e ]
      __binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :c2, :e ]
    end
    ::Perspective::Bindings::MockNestedB.new.instance_eval do
      has_binding?( :c1 ).should == true
      has_binding?( :c2 ).should == true
      __binding__( :c1 ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :c1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :c2 ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :c2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      __binding__( :c1 ).__route__.should == nil
      __binding__( :c1 ).__binding__( :d ).__route__.should == [ :c1 ]
      __binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :c1, :d ]
      __binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :c1, :d ]
      __binding__( :c2 ).__route__.should == nil
      __binding__( :c2 ).__binding__( :e ).__route__.should == [ :c2 ]
      __binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :c2, :e ]
      __binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :c2, :e ]
    end
    
    class ::Perspective::Bindings::MockNestedA
      include ::Perspective::Bindings
      attr_binding :b, ::Perspective::Bindings::MockNestedB
    end

    ::Perspective::Bindings::MockNestedA.module_eval do
      has_binding?( :b ).should == true
      __binding__( :b ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :b ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :b ).__route__.should == nil
      __binding__( :b ).__binding__( :c1 ).__route__.should == [ :b ]
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :b, :c1 ]
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :b, :c1, :d ]
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :b, :c1, :d ]
      __binding__( :b ).__binding__( :c2 ).__route__.should == [ :b ]
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :b, :c2 ]
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :b, :c2, :e ]
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :b, :c2, :e ]
    end
    ::Perspective::Bindings::MockNestedA.new.instance_eval do
      has_binding?( :b ).should == true
      __binding__( :b ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :b ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      __binding__( :b ).__route__.should == nil
      __binding__( :b ).__binding__( :c1 ).__route__.should == [ :b ]
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :b, :c1 ]
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :b, :c1, :d ]
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :b, :c1, :d ]
      __binding__( :b ).__binding__( :c2 ).__route__.should == [ :b ]
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :b, :c2 ]
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :b, :c2, :e ]
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :b, :c2, :e ]
    end
    
    class ::Perspective::Bindings::MockWithNested
      include ::Perspective::Bindings
      attr_binding :a, ::Perspective::Bindings::MockNestedA
    end

    ::Perspective::Bindings::MockWithNested.module_eval do
      has_binding?( :a ).should == true
      __binding__( :a ).is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      __binding__( :a ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :a ).has_binding?( :b ).should == true
      __binding__( :a ).__binding__( :b ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :a ).__route__.should == nil
      __binding__( :a ).__binding__( :b ).__route__.should == [ :a ]
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__route__.should == [ :a, :b ]
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :a, :b, :c1 ]
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :a, :b, :c1, :d ]
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :a, :b, :c1, :d ]
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__route__.should == [ :a, :b ]
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :a, :b, :c2 ]
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :a, :b, :c2, :e ]
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :a, :b, :c2, :e ]
    end
    ::Perspective::Bindings::MockWithNested.new.instance_eval do
      has_binding?( :a ).should == true
      __binding__( :a ).is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      __binding__( :a ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :a ).has_binding?( :b ).should == true
      __binding__( :a ).__binding__( :b ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      __binding__( :a ).__route__.should == nil
      __binding__( :a ).__binding__( :b ).__route__.should == [ :a ]
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__route__.should == [ :a, :b ]
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :a, :b, :c1 ]
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :a, :b, :c1, :d ]
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :a, :b, :c1, :d ]
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__route__.should == [ :a, :b ]
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :a, :b, :c2 ]
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :a, :b, :c2, :e ]
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :a, :b, :c2, :e ]
    end
    
    module ::Perspective::Bindings::MockModule
      include ::Perspective::Bindings
      attr_binding :some_binding
      attr_text :some_text
      attr_numbers :some_numbers
      attr_binding :nested, ::Perspective::Bindings::MockWithNested
    end

    ::Perspective::Bindings::MockModule.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :nested ).__route__.should == nil
      __binding__( :nested ).__binding__( :a ).__route__.should == [ :nested ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__route__.should == [ :nested, :a ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :nested, :a, :b, :c1 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :nested, :a, :b, :c2 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
    end

    module ::Perspective::Bindings::MockModule2
      include ::Perspective::Bindings::MockModule
    end

    ::Perspective::Bindings::MockModule2.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :nested ).__route__.should == nil
      __binding__( :nested ).__binding__( :a ).__route__.should == [ :nested ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__route__.should == [ :nested, :a ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :nested, :a, :b, :c1 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :nested, :a, :b, :c2 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
    end

    class ::Perspective::Bindings::MockClass
      include ::Perspective::Bindings::MockModule
    end

    ::Perspective::Bindings::MockClass.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :nested ).__route__.should == nil
      __binding__( :nested ).__binding__( :a ).__route__.should == [ :nested ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__route__.should == [ :nested, :a ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :nested, :a, :b, :c1 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :nested, :a, :b, :c2 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
    end
    ::Perspective::Bindings::MockClass.new.instance_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      __binding__( :nested ).__route__.should == nil
      __binding__( :nested ).__binding__( :a ).__route__.should == [ :nested ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__route__.should == [ :nested, :a ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :nested, :a, :b, :c1 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :nested, :a, :b, :c2 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
    end

    module ::Perspective::Bindings::MockModule2
      include ::Perspective::Bindings::MockModule
    end

    ::Perspective::Bindings::MockModule2.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :nested ).__route__.should == nil
      __binding__( :nested ).__binding__( :a ).__route__.should == [ :nested ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__route__.should == [ :nested, :a ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :nested, :a, :b, :c1 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :nested, :a, :b, :c2 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
    end
    
    class ::Perspective::Bindings::MockClass2
      include ::Perspective::Bindings::MockModule2
    end

    ::Perspective::Bindings::MockClass2.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :nested ).__route__.should == nil
      __binding__( :nested ).__binding__( :a ).__route__.should == [ :nested ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__route__.should == [ :nested, :a ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :nested, :a, :b, :c1 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :nested, :a, :b, :c2 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
    end
    ::Perspective::Bindings::MockClass2.new.instance_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      __binding__( :nested ).__route__.should == nil
      __binding__( :nested ).__binding__( :a ).__route__.should == [ :nested ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__route__.should == [ :nested, :a ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__route__.should == [ :nested, :a, :b, :c1 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c1, :d ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__route__.should == [ :nested, :a, :b ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__route__.should == [ :nested, :a, :b, :c2 ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).__route__.should == [ :nested, :a, :b, :c2, :e ]
    end
    
  end

end
