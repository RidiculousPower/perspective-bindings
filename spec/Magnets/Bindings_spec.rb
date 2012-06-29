
require_relative '../../lib/magnets/bindings.rb'

describe ::Magnets::Bindings do
  
  it 'can cascade definitions' do

    class ::Magnets::Bindings::MockNestedE
      include ::Magnets::Bindings
      attr_text :text1, :text2
    end

    ::Magnets::Bindings::MockNestedE.module_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      __binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __route__.should == nil
      __binding__( :text1 ).__route__.should == nil
      __binding__( :text2 ).__route__.should == nil
    end
    ::Magnets::Bindings::MockNestedE.new.instance_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      __binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __route__.should == nil
      __binding__( :text1 ).__route__.should == nil
      __binding__( :text2 ).__route__.should == nil
    end

    class ::Magnets::Bindings::MockNestedD
      include ::Magnets::Bindings
      attr_text :text1, :text2
    end

    ::Magnets::Bindings::MockNestedD.module_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      __binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __route__.should == nil
      __binding__( :text1 ).__route__.should == nil
      __binding__( :text2 ).__route__.should == nil
    end
    ::Magnets::Bindings::MockNestedD.new.instance_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      __binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __route__.should == nil
      __binding__( :text1 ).__route__.should == nil
      __binding__( :text2 ).__route__.should == nil
    end

    class ::Magnets::Bindings::MockNestedC2
      include ::Magnets::Bindings
      attr_binding :e, ::Magnets::Bindings::MockNestedE
    end

    ::Magnets::Bindings::MockNestedC2.module_eval do
      has_binding?( :e ).should == true
      __binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :e ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :e ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :e ).__route__.should == nil
      __binding__( :e ).__binding__( :text1 ).__route__.should == [ :e ]
      __binding__( :e ).__binding__( :text2 ).__route__.should == [ :e ]
    end
    ::Magnets::Bindings::MockNestedC2.new.instance_eval do
      has_binding?( :e ).should == true
      __binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :e ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :e ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      __binding__( :e ).__route__.should == nil
      __binding__( :e ).__binding__( :text1 ).__route__.should == [ :e ]
      __binding__( :e ).__binding__( :text2 ).__route__.should == [ :e ]
    end
    
    class ::Magnets::Bindings::MockNestedC1
      include ::Magnets::Bindings
      attr_binding :d, ::Magnets::Bindings::MockNestedD
    end

    ::Magnets::Bindings::MockNestedC1.module_eval do
      has_binding?( :d ).should == true
      __binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      __binding__( :d ).__route__.should == nil
      __binding__( :d ).__binding__( :text1 ).__route__.should == [ :d ]
      __binding__( :d ).__binding__( :text2 ).__route__.should == [ :d ]
    end
    ::Magnets::Bindings::MockNestedC1.new.instance_eval do
      has_binding?( :d ).should == true
      __binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :d ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :d ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      __binding__( :d ).__route__.should == nil
      __binding__( :d ).__binding__( :text1 ).__route__.should == [ :d ]
      __binding__( :d ).__binding__( :text2 ).__route__.should == [ :d ]
    end

    class ::Magnets::Bindings::MockNestedB
      include ::Magnets::Bindings
      attr_binding :c1, ::Magnets::Bindings::MockNestedC1
      attr_binding :c2, ::Magnets::Bindings::MockNestedC2
    end

    ::Magnets::Bindings::MockNestedB.module_eval do
      has_binding?( :c1 ).should == true
      has_binding?( :c2 ).should == true
      __binding__( :c1 ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :c1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :c2 ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :c2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
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
    ::Magnets::Bindings::MockNestedB.new.instance_eval do
      has_binding?( :c1 ).should == true
      has_binding?( :c2 ).should == true
      __binding__( :c1 ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :c1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :c2 ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :c2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
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
    
    class ::Magnets::Bindings::MockNestedA
      include ::Magnets::Bindings
      attr_binding :b, ::Magnets::Bindings::MockNestedB
    end

    ::Magnets::Bindings::MockNestedA.module_eval do
      has_binding?( :b ).should == true
      __binding__( :b ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :b ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
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
    ::Magnets::Bindings::MockNestedA.new.instance_eval do
      has_binding?( :b ).should == true
      __binding__( :b ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :b ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
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
    
    class ::Magnets::Bindings::MockWithNested
      include ::Magnets::Bindings
      attr_binding :a, ::Magnets::Bindings::MockNestedA
    end

    ::Magnets::Bindings::MockWithNested.module_eval do
      has_binding?( :a ).should == true
      __binding__( :a ).is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      __binding__( :a ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == false
      __binding__( :a ).has_binding?( :b ).should == true
      __binding__( :a ).__binding__( :b ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
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
    ::Magnets::Bindings::MockWithNested.new.instance_eval do
      has_binding?( :a ).should == true
      __binding__( :a ).is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
      __binding__( :a ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __binding__( :a ).has_binding?( :b ).should == true
      __binding__( :a ).__binding__( :b ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
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
    
    module ::Magnets::Bindings::MockModule
      include ::Magnets::Bindings
      attr_binding :some_binding
      attr_text :some_text
      attr_numbers :some_numbers
      attr_binding :nested, ::Magnets::Bindings::MockWithNested
    end

    ::Magnets::Bindings::MockModule.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
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

    module ::Magnets::Bindings::MockModule2
      include ::Magnets::Bindings::MockModule
    end

    ::Magnets::Bindings::MockModule2.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
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

    class ::Magnets::Bindings::MockClass
      include ::Magnets::Bindings::MockModule
    end

    ::Magnets::Bindings::MockClass.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
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
    ::Magnets::Bindings::MockClass.new.instance_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
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

    module ::Magnets::Bindings::MockModule2
      include ::Magnets::Bindings::MockModule
    end

    ::Magnets::Bindings::MockModule2.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
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
    
    class ::Magnets::Bindings::MockClass2
      include ::Magnets::Bindings::MockModule2

    end

    ::Magnets::Bindings::MockClass2.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::ClassBinding::NestedClassBinding ).should == true
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
    ::Magnets::Bindings::MockClass2.new.instance_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      __binding__( :nested ).has_binding?( :a ).should == true
      __binding__( :nested ).__binding__( :a ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).has_binding?( :b ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).has_binding?( :c2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).has_binding?( :d ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c1 ).__binding__( :d ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).has_binding?( :e ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text1 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).has_binding?( :text2 ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text1 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __binding__( :nested ).__binding__( :a ).__binding__( :b ).__binding__( :c2 ).__binding__( :e ).__binding__( :text2 ).is_a?( ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
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
