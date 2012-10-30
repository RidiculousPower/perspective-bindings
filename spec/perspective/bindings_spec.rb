
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
      text1.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      text2.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __route__.should == nil
      text1.__route__.should == nil
      text2.__route__.should == nil
    end
    ::Perspective::Bindings::MockNestedE.new.instance_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      text1.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      text2.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __route__.should == nil
      text1.__route__.should == nil
      text2.__route__.should == nil
    end

    class ::Perspective::Bindings::MockNestedD
      include ::Perspective::Bindings
      attr_text :text1, :text2
    end

    ::Perspective::Bindings::MockNestedD.module_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      text1.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      text2.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      __route__.should == nil
      text1.__route__.should == nil
      text2.__route__.should == nil
    end
    ::Perspective::Bindings::MockNestedD.new.instance_eval do
      has_binding?( :text1 ).should == true
      has_binding?( :text2 ).should == true
      text1.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      text2.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      __route__.should == nil
      text1.__route__.should == nil
      text2.__route__.should == nil
    end

    class ::Perspective::Bindings::MockNestedC2
      include ::Perspective::Bindings
      attr_binding :e, ::Perspective::Bindings::MockNestedE
    end

    ::Perspective::Bindings::MockNestedC2.module_eval do
      has_binding?( :e ).should == true
      e.has_binding?( :text1 ).should == true
      e.has_binding?( :text2 ).should == true
      e.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      e.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      e.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      e.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      e.__route__.should == nil
      e.text1.__route__.should == [ :e ]
      e.text2.__route__.should == [ :e ]
    end
    ::Perspective::Bindings::MockNestedC2.new.instance_eval do
      has_binding?( :e ).should == true
      e.has_binding?( :text1 ).should == true
      e.has_binding?( :text2 ).should == true
      e.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      e.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      binding_e = e
      binding_e.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      e.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      e.__route__.should == nil
      e.text1.__route__.should == [ :e ]
      e.text2.__route__.should == [ :e ]
    end
    
    class ::Perspective::Bindings::MockNestedC1
      include ::Perspective::Bindings
      attr_binding :d, ::Perspective::Bindings::MockNestedD
    end

    ::Perspective::Bindings::MockNestedC1.module_eval do
      has_binding?( :d ).should == true
      d.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      d.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      d.has_binding?( :text1 ).should == true
      d.has_binding?( :text2 ).should == true
      d.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      d.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      d.__route__.should == nil
      d.text1.__route__.should == [ :d ]
      d.text2.__route__.should == [ :d ]
    end
    ::Perspective::Bindings::MockNestedC1.new.instance_eval do
      has_binding?( :d ).should == true
      d.has_binding?( :text1 ).should == true
      d.has_binding?( :text2 ).should == true
      d.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      d.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      d.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      d.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      d.__route__.should == nil
      d.text1.__route__.should == [ :d ]
      d.text2.__route__.should == [ :d ]
    end

    class ::Perspective::Bindings::MockNestedB
      include ::Perspective::Bindings
      attr_binding :c1, ::Perspective::Bindings::MockNestedC1
      attr_binding :c2, ::Perspective::Bindings::MockNestedC2
    end

    ::Perspective::Bindings::MockNestedB.module_eval do
      has_binding?( :c1 ).should == true
      has_binding?( :c2 ).should == true
      c1.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      c1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      c2.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      c2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      c1.has_binding?( :d ).should == true
      c1.d.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      c1.d.has_binding?( :text1 ).should == true
      c1.d.has_binding?( :text2 ).should == true
      c1.d.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      c1.d.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      c2.has_binding?( :e ).should == true
      c2.e.has_binding?( :text1 ).should == true
      c2.e.has_binding?( :text2 ).should == true
      c2.e.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      c2.e.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      c1.__route__.should == nil
      c1.d.__route__.should == [ :c1 ]
      c1.d.text1.__route__.should == [ :c1, :d ]
      c1.d.text2.__route__.should == [ :c1, :d ]
      c2.__route__.should == nil
      c2.e.__route__.should == [ :c2 ]
      c2.e.text1.__route__.should == [ :c2, :e ]
      c2.e.text2.__route__.should == [ :c2, :e ]
    end
    ::Perspective::Bindings::MockNestedB.new.instance_eval do
      has_binding?( :c1 ).should == true
      has_binding?( :c2 ).should == true
      c1.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      c1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      c2.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      c2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      c1.has_binding?( :d ).should == true
      c1.d.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      c1.d.has_binding?( :text1 ).should == true
      c1.d.has_binding?( :text2 ).should == true
      c1.d.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      c1.d.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      c2.has_binding?( :e ).should == true
      c2.e.has_binding?( :text1 ).should == true
      c2.e.has_binding?( :text2 ).should == true
      c2.e.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      c2.e.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      c1.__route__.should == nil
      c1.d.__route__.should == [ :c1 ]
      c1.d.text1.__route__.should == [ :c1, :d ]
      c1.d.text2.__route__.should == [ :c1, :d ]
      c2.__route__.should == nil
      c2.e.__route__.should == [ :c2 ]
      c2.e.text1.__route__.should == [ :c2, :e ]
      c2.e.text2.__route__.should == [ :c2, :e ]
    end
    
    class ::Perspective::Bindings::MockNestedA
      include ::Perspective::Bindings
      attr_binding :b, ::Perspective::Bindings::MockNestedB
    end

    ::Perspective::Bindings::MockNestedA.module_eval do
      has_binding?( :b ).should == true
      b.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      b.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      b.has_binding?( :c1 ).should == true
      b.has_binding?( :c2 ).should == true
      b.c2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      b.c1.has_binding?( :d ).should == true
      b.c1.d.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      b.c1.d.has_binding?( :text1 ).should == true
      b.c1.d.has_binding?( :text2 ).should == true
      b.c1.d.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      b.c1.d.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      b.c2.has_binding?( :e ).should == true
      b.c2.e.has_binding?( :text1 ).should == true
      b.c2.e.has_binding?( :text2 ).should == true
      b.c2.e.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      b.c2.e.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      b.__route__.should == nil
      b.c1.__route__.should == [ :b ]
      b.c1.d.__route__.should == [ :b, :c1 ]
      b.c1.d.text1.__route__.should == [ :b, :c1, :d ]
      b.c1.d.text2.__route__.should == [ :b, :c1, :d ]
      b.c2.__route__.should == [ :b ]
      b.c2.e.__route__.should == [ :b, :c2 ]
      b.c2.e.text1.__route__.should == [ :b, :c2, :e ]
      b.c2.e.text2.__route__.should == [ :b, :c2, :e ]
    end
    ::Perspective::Bindings::MockNestedA.new.instance_eval do
      has_binding?( :b ).should == true
      b.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      b.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      b.has_binding?( :c1 ).should == true
      b.has_binding?( :c2 ).should == true
      b.c2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      b.c1.has_binding?( :d ).should == true
      b.c1.d.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      b.c1.d.has_binding?( :text1 ).should == true
      b.c1.d.has_binding?( :text2 ).should == true
      b.c1.d.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      b.c1.d.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      b.c2.has_binding?( :e ).should == true
      b.c2.e.has_binding?( :text1 ).should == true
      b.c2.e.has_binding?( :text2 ).should == true
      b.c2.e.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      b.c2.e.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      b.__route__.should == nil
      b.c1.__route__.should == [ :b ]
      b.c1.d.__route__.should == [ :b, :c1 ]
      b.c1.d.text1.__route__.should == [ :b, :c1, :d ]
      b.c1.d.text2.__route__.should == [ :b, :c1, :d ]
      b.c2.__route__.should == [ :b ]
      b.c2.e.__route__.should == [ :b, :c2 ]
      b.c2.e.text1.__route__.should == [ :b, :c2, :e ]
      b.c2.e.text2.__route__.should == [ :b, :c2, :e ]
    end
    
    class ::Perspective::Bindings::MockWithNested
      include ::Perspective::Bindings
      attr_binding :a, ::Perspective::Bindings::MockNestedA
    end

    ::Perspective::Bindings::MockWithNested.module_eval do
      has_binding?( :a ).should == true
      a.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      a.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == false
      a.has_binding?( :b ).should == true
      a.b.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      a.b.has_binding?( :c1 ).should == true
      a.b.has_binding?( :c2 ).should == true
      a.b.c2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      a.b.c1.has_binding?( :d ).should == true
      a.b.c1.d.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      a.b.c1.d.has_binding?( :text1 ).should == true
      a.b.c1.d.has_binding?( :text2 ).should == true
      a.b.c1.d.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      a.b.c1.d.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      a.b.c2.has_binding?( :e ).should == true
      a.b.c2.e.has_binding?( :text1 ).should == true
      a.b.c2.e.has_binding?( :text2 ).should == true
      a.b.c2.e.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      a.b.c2.e.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      a.__route__.should == nil
      a.b.__route__.should == [ :a ]
      a.b.c1.__route__.should == [ :a, :b ]
      a.b.c1.d.__route__.should == [ :a, :b, :c1 ]
      a.b.c1.d.text1.__route__.should == [ :a, :b, :c1, :d ]
      a.b.c1.d.text2.__route__.should == [ :a, :b, :c1, :d ]
      a.b.c2.__route__.should == [ :a, :b ]
      a.b.c2.e.__route__.should == [ :a, :b, :c2 ]
      a.b.c2.e.text1.__route__.should == [ :a, :b, :c2, :e ]
      a.b.c2.e.text2.__route__.should == [ :a, :b, :c2, :e ]
    end
    ::Perspective::Bindings::MockWithNested.new.instance_eval do
      has_binding?( :a ).should == true
      a.is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
      a.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == false
      a.has_binding?( :b ).should == true
      a.b.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      a.b.has_binding?( :c1 ).should == true
      a.b.has_binding?( :c2 ).should == true
      a.b.c2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      a.b.c1.has_binding?( :d ).should == true
      a.b.c1.d.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      a.b.c1.d.has_binding?( :text1 ).should == true
      a.b.c1.d.has_binding?( :text2 ).should == true
      a.b.c1.d.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      a.b.c1.d.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      a.b.c2.has_binding?( :e ).should == true
      a.b.c2.e.has_binding?( :text1 ).should == true
      a.b.c2.e.has_binding?( :text2 ).should == true
      a.b.c2.e.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      a.b.c2.e.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      a.__route__.should == nil
      a.b.__route__.should == [ :a ]
      a.b.c1.__route__.should == [ :a, :b ]
      a.b.c1.d.__route__.should == [ :a, :b, :c1 ]
      a.b.c1.d.text1.__route__.should == [ :a, :b, :c1, :d ]
      a.b.c1.d.text2.__route__.should == [ :a, :b, :c1, :d ]
      a.b.c2.__route__.should == [ :a, :b ]
      a.b.c2.e.__route__.should == [ :a, :b, :c2 ]
      a.b.c2.e.text1.__route__.should == [ :a, :b, :c2, :e ]
      a.b.c2.e.text2.__route__.should == [ :a, :b, :c2, :e ]
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
      nested.has_binding?( :a ).should == true
      nested.a.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.has_binding?( :b ).should == true
      nested.a.b.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.has_binding?( :c1 ).should == true
      nested.a.b.has_binding?( :c2 ).should == true
      nested.a.b.c2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.has_binding?( :d ).should == true
      nested.a.b.c1.d.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.has_binding?( :text1 ).should == true
      nested.a.b.c1.d.has_binding?( :text2 ).should == true
      nested.a.b.c1.d.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.has_binding?( :e ).should == true
      nested.a.b.c2.e.has_binding?( :text1 ).should == true
      nested.a.b.c2.e.has_binding?( :text2 ).should == true
      nested.a.b.c2.e.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.e.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      nested.__route__.should == nil
      nested.a.__route__.should == [ :nested ]
      nested.a.b.__route__.should == [ :nested, :a ]
      nested.a.b.c1.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c1.d.__route__.should == [ :nested, :a, :b, :c1 ]
      nested.a.b.c1.d.text1.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c1.d.text2.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c2.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c2.e.__route__.should == [ :nested, :a, :b, :c2 ]
      nested.a.b.c2.e.text1.__route__.should == [ :nested, :a, :b, :c2, :e ]
      nested.a.b.c2.e.text2.__route__.should == [ :nested, :a, :b, :c2, :e ]
    end

    module ::Perspective::Bindings::MockModule2
      include ::Perspective::Bindings::MockModule
    end

    ::Perspective::Bindings::MockModule2.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      nested.has_binding?( :a ).should == true
      nested.a.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.has_binding?( :b ).should == true
      nested.a.b.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.has_binding?( :c1 ).should == true
      nested.a.b.has_binding?( :c2 ).should == true
      nested.a.b.c2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.has_binding?( :d ).should == true
      nested.a.b.c1.d.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.has_binding?( :text1 ).should == true
      nested.a.b.c1.d.has_binding?( :text2 ).should == true
      nested.a.b.c1.d.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.has_binding?( :e ).should == true
      nested.a.b.c2.e.has_binding?( :text1 ).should == true
      nested.a.b.c2.e.has_binding?( :text2 ).should == true
      nested.a.b.c2.e.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.e.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      nested.__route__.should == nil
      nested.a.__route__.should == [ :nested ]
      nested.a.b.__route__.should == [ :nested, :a ]
      nested.a.b.c1.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c1.d.__route__.should == [ :nested, :a, :b, :c1 ]
      nested.a.b.c1.d.text1.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c1.d.text2.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c2.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c2.e.__route__.should == [ :nested, :a, :b, :c2 ]
      nested.a.b.c2.e.text1.__route__.should == [ :nested, :a, :b, :c2, :e ]
      nested.a.b.c2.e.text2.__route__.should == [ :nested, :a, :b, :c2, :e ]
    end

    class ::Perspective::Bindings::MockClass
      include ::Perspective::Bindings::MockModule
    end

    ::Perspective::Bindings::MockClass.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      nested.has_binding?( :a ).should == true
      nested.a.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.has_binding?( :b ).should == true
      nested.a.b.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.has_binding?( :c1 ).should == true
      nested.a.b.has_binding?( :c2 ).should == true
      nested.a.b.c2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.has_binding?( :d ).should == true
      nested.a.b.c1.d.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.has_binding?( :text1 ).should == true
      nested.a.b.c1.d.has_binding?( :text2 ).should == true
      nested.a.b.c1.d.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.has_binding?( :e ).should == true
      nested.a.b.c2.e.has_binding?( :text1 ).should == true
      nested.a.b.c2.e.has_binding?( :text2 ).should == true
      nested.a.b.c2.e.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.e.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      nested.__route__.should == nil
      nested.a.__route__.should == [ :nested ]
      nested.a.b.__route__.should == [ :nested, :a ]
      nested.a.b.c1.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c1.d.__route__.should == [ :nested, :a, :b, :c1 ]
      nested.a.b.c1.d.text1.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c1.d.text2.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c2.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c2.e.__route__.should == [ :nested, :a, :b, :c2 ]
      nested.a.b.c2.e.text1.__route__.should == [ :nested, :a, :b, :c2, :e ]
      nested.a.b.c2.e.text2.__route__.should == [ :nested, :a, :b, :c2, :e ]
    end
    ::Perspective::Bindings::MockClass.new.instance_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      nested.has_binding?( :a ).should == true
      nested.a.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.has_binding?( :b ).should == true
      nested.a.b.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.has_binding?( :c1 ).should == true
      nested.a.b.has_binding?( :c2 ).should == true
      nested.a.b.c2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c1.has_binding?( :d ).should == true
      nested.a.b.c1.d.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c1.d.has_binding?( :text1 ).should == true
      nested.a.b.c1.d.has_binding?( :text2 ).should == true
      nested.a.b.c1.d.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c1.d.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c2.has_binding?( :e ).should == true
      nested.a.b.c2.e.has_binding?( :text1 ).should == true
      nested.a.b.c2.e.has_binding?( :text2 ).should == true
      nested.a.b.c2.e.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c2.e.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      nested.__route__.should == nil
      nested.a.__route__.should == [ :nested ]
      nested.a.b.__route__.should == [ :nested, :a ]
      nested.a.b.c1.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c1.d.__route__.should == [ :nested, :a, :b, :c1 ]
      nested.a.b.c1.d.text1.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c1.d.text2.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c2.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c2.e.__route__.should == [ :nested, :a, :b, :c2 ]
      nested.a.b.c2.e.text1.__route__.should == [ :nested, :a, :b, :c2, :e ]
      nested.a.b.c2.e.text2.__route__.should == [ :nested, :a, :b, :c2, :e ]
    end

    module ::Perspective::Bindings::MockModule2
      include ::Perspective::Bindings::MockModule
    end

    ::Perspective::Bindings::MockModule2.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      nested.has_binding?( :a ).should == true
      nested.a.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.has_binding?( :b ).should == true
      nested.a.b.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.has_binding?( :c1 ).should == true
      nested.a.b.has_binding?( :c2 ).should == true
      nested.a.b.c2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.has_binding?( :d ).should == true
      nested.a.b.c1.d.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.has_binding?( :text1 ).should == true
      nested.a.b.c1.d.has_binding?( :text2 ).should == true
      nested.a.b.c1.d.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.has_binding?( :e ).should == true
      nested.a.b.c2.e.has_binding?( :text1 ).should == true
      nested.a.b.c2.e.has_binding?( :text2 ).should == true
      nested.a.b.c2.e.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.e.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      nested.__route__.should == nil
      nested.a.__route__.should == [ :nested ]
      nested.a.b.__route__.should == [ :nested, :a ]
      nested.a.b.c1.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c1.d.__route__.should == [ :nested, :a, :b, :c1 ]
      nested.a.b.c1.d.text1.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c1.d.text2.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c2.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c2.e.__route__.should == [ :nested, :a, :b, :c2 ]
      nested.a.b.c2.e.text1.__route__.should == [ :nested, :a, :b, :c2, :e ]
      nested.a.b.c2.e.text2.__route__.should == [ :nested, :a, :b, :c2, :e ]
    end
    
    class ::Perspective::Bindings::MockClass2
      include ::Perspective::Bindings::MockModule2
    end

    ::Perspective::Bindings::MockClass2.module_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      nested.has_binding?( :a ).should == true
      nested.a.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.has_binding?( :b ).should == true
      nested.a.b.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.has_binding?( :c1 ).should == true
      nested.a.b.has_binding?( :c2 ).should == true
      nested.a.b.c2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.has_binding?( :d ).should == true
      nested.a.b.c1.d.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.has_binding?( :text1 ).should == true
      nested.a.b.c1.d.has_binding?( :text2 ).should == true
      nested.a.b.c1.d.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c1.d.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.has_binding?( :e ).should == true
      nested.a.b.c2.e.has_binding?( :text1 ).should == true
      nested.a.b.c2.e.has_binding?( :text2 ).should == true
      nested.a.b.c2.e.text1.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      nested.a.b.c2.e.text2.is_a?( ::Perspective::Bindings::ClassBinding::NestedClassBinding ).should == true
      __route__.should == nil
      nested.__route__.should == nil
      nested.a.__route__.should == [ :nested ]
      nested.a.b.__route__.should == [ :nested, :a ]
      nested.a.b.c1.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c1.d.__route__.should == [ :nested, :a, :b, :c1 ]
      nested.a.b.c1.d.text1.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c1.d.text2.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c2.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c2.e.__route__.should == [ :nested, :a, :b, :c2 ]
      nested.a.b.c2.e.text1.__route__.should == [ :nested, :a, :b, :c2, :e ]
      nested.a.b.c2.e.text2.__route__.should == [ :nested, :a, :b, :c2, :e ]
    end
    ::Perspective::Bindings::MockClass2.new.instance_eval do
      has_binding?( :some_binding ).should == true
      has_binding?( :some_text ).should == true
      has_binding?( :some_numbers ).should == true
      has_binding?( :nested ).should == true
      nested.has_binding?( :a ).should == true
      nested.a.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.has_binding?( :b ).should == true
      nested.a.b.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.has_binding?( :c1 ).should == true
      nested.a.b.has_binding?( :c2 ).should == true
      nested.a.b.c2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c1.has_binding?( :d ).should == true
      nested.a.b.c1.d.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c1.d.has_binding?( :text1 ).should == true
      nested.a.b.c1.d.has_binding?( :text2 ).should == true
      nested.a.b.c1.d.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c1.d.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c2.has_binding?( :e ).should == true
      nested.a.b.c2.e.has_binding?( :text1 ).should == true
      nested.a.b.c2.e.has_binding?( :text2 ).should == true
      nested.a.b.c2.e.text1.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      nested.a.b.c2.e.text2.is_a?( ::Perspective::Bindings::InstanceBinding::NestedInstanceBinding ).should == true
      __route__.should == nil
      nested.__route__.should == nil
      nested.a.__route__.should == [ :nested ]
      nested.a.b.__route__.should == [ :nested, :a ]
      nested.a.b.c1.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c1.d.__route__.should == [ :nested, :a, :b, :c1 ]
      nested.a.b.c1.d.text1.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c1.d.text2.__route__.should == [ :nested, :a, :b, :c1, :d ]
      nested.a.b.c2.__route__.should == [ :nested, :a, :b ]
      nested.a.b.c2.e.__route__.should == [ :nested, :a, :b, :c2 ]
      nested.a.b.c2.e.text1.__route__.should == [ :nested, :a, :b, :c2, :e ]
      nested.a.b.c2.e.text2.__route__.should == [ :nested, :a, :b, :c2, :e ]
    end
    
  end

end