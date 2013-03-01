# -*- encoding : utf-8 -*-

require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::BindingTypes::ContainerBindings::TypesController do
  
  let( :types_controller ) { ::Perspective::BindingTypes::ContainerBindings::TypesController }
  let( :type_container ) { ::Perspective::BindingTypes::ContainerBindings }
  let( :binding_type ) { ::Perspective::BindingTypes::ContainerBindings::Binding }
  let( :bound_container ) do
    ::Module.new do
      def self.«root»
        return self
      end
      def self.«root_string»
        return @«root_string» ||= '<root:' << to_s << '>'
      end
    end
  end
  
  let( :container_1 ) { ::Class.new }
  let( :container_2 ) { ::Class.new }
  let( :container_3 ) { ::Class.new }

  ######################################
  #  ::parse_binding_declaration_args  #
  ######################################
  
  context '::parse_binding_declaration_args' do
    let( :parse_binding_declaration_args ) { types_controller.parse_binding_declaration_args( *args ) }
    context 'names' do
      let( :args ) { [ :binding_one, :binding_two, :binding_three ] }
      let( :result ) { { :binding_one => nil, :binding_two => nil, :binding_three => nil } }
      it 'will return a hash with names paired with nil for container class' do
        parse_binding_declaration_args.should == result
      end
    end
    context 'names list with container class' do
      let( :args ) { [ :binding_one, container_1 ] }
      let( :result ) { { :binding_one => container_1 } }
      it 'will return a hash with name paired with container class' do
        parse_binding_declaration_args.should == result
      end
    end
    context 'list of names ending with container class' do
      let( :args ) { [ :binding_one, :binding_two, :binding_three, container_1 ] }
      let( :result ) { { :binding_one => container_1, :binding_two => container_1, :binding_three => container_1 } }
      it 'will return a hash with each name paired with the single provided container class' do
        parse_binding_declaration_args.should == result
      end
    end
    context 'names hash with container classes' do
      let( :args ) { [ { :binding_one => container_1, :binding_two => container_2, :binding_three => container_3 } ] }
      let( :result ) { { :binding_one => container_1, :binding_two => container_2, :binding_three => container_3 } }
      it 'will return a hash with each name paired with the corresponding container class' do
        parse_binding_declaration_args.should == result
      end
    end
    context 'list of names ending with hash with container class' do
      let( :args ) { [ :binding_one, :binding_two, :binding_three => container_1 ] }
      let( :result ) { { :binding_one => container_1, :binding_two => container_1, :binding_three => container_1 } }
      it 'will return a hash with each name paired with the single provided container class' do
        parse_binding_declaration_args.should == result
      end
    end
    context 'combined' do
      let( :args ) { [ :binding_one, :binding_two, :binding_three, :binding_four, container_1, 
                       :binding_five, { :binding_six => container_2,
                                        :binding_seven => container_3 },
                                        :binding_eight ] }
      let( :result ) { { :binding_one   => container_1, 
                         :binding_two   => container_1, 
                         :binding_three => container_1,
                         :binding_four  => container_1,
                         :binding_five  => container_2,
                         :binding_six   => container_2,
                         :binding_seven => container_3,
                         :binding_eight => nil } }
      it 'will return a hash with each name paired with the container class that follows it (whether immediately or not) or nil if none follows' do
        parse_binding_declaration_args.should == result
      end
    end
  end

  ##########################
  #  ::new_class_bindings  #
  ##########################
  
  context '::new_class_bindings' do
    it 'creates new class bindings for a container, a list of names, and an optional block' do
      new_bindings = types_controller.new_class_bindings( binding_type, bound_container, :some_name, :some_other_name, :another_name )
      new_bindings.each do |this_binding|
        this_binding.is_a?( ::Perspective::Bindings::BindingBase::ClassBinding ).should be true
        this_binding.is_a?( ::Perspective::BindingTypes::ContainerBindings::ClassBinding ).should be true
        this_binding.is_a?( type_container::Binding ).should be true
        this_binding.«bound_container».should be bound_container
      end
    end
  end
  

end
