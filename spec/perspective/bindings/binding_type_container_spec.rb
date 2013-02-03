
require_relative '../../../lib/perspective/bindings.rb'

###
# Method controller for groups of binding types.
#
describe ::Perspective::Bindings::BindingTypeContainer do
  
  let( :parent_type_container_name ) { :parent_type_container }
  let( :child_type_container_name ) { :child_type_container }
  let( :child_without_subclassing_type_container_name ) { :child_type_container }
  let( :parent_type_container ) { ::Perspective::Bindings::BindingTypeContainer.new( parent_type_container_name ) }
  let( :child_type_container ) { ::Perspective::Bindings::BindingTypeContainer.new( child_type_container_name, parent_type_container ) }
  let( :child_without_subclassing_type_container ) { ::Perspective::Bindings::BindingTypeContainer.new( child_without_subclassing_type_container_name, parent_type_container, false ) }
  
  ##################################################################################################
  #    private #####################################################################################
  ##################################################################################################
  
	#######################################  Method Names  ###########################################

  context '================  Method Names  ================' do

    let( :instance ) { parent_type_container }
    let( :binding_name ) { 'text' }

    ################################
    #  single_binding_method_name  #
    ################################
  
    context '#single_binding_method_name' do
      let( :expected_binding_method_name ) { 'attr_text' }
      let( :single_binding_method_name ) do
        _binding_name = binding_name
        instance.instance_eval { single_binding_method_name( _binding_name ) }
      end
      it 'will prepend attr_' do
        single_binding_method_name.should == expected_binding_method_name
      end
    end
  
    ##################################
    #  multiple_binding_method_name  #
    ##################################
  
    context '#multiple_binding_method_name' do
      let( :multiple_binding_method_name ) do
        _binding_name = binding_name
        instance.instance_eval { multiple_binding_method_name( _binding_name ) }
      end
      context 'when type ends with anything other than s or x' do
        let( :expected_binding_method_name ) { 'attr_texts' }
        it 'will prepend attr_ and append -s' do
          multiple_binding_method_name.should == expected_binding_method_name
        end
      end
      context 'when type ends with s' do
        let( :binding_name ) { 'texts' }
        let( :expected_binding_method_name ) { 'attr_textses' }
        it 'it will prepend attr_ and append -es' do
          multiple_binding_method_name.should == expected_binding_method_name
        end
      end
      context 'when type ends with x' do
        let( :binding_name ) { 'tex' }
        let( :expected_binding_method_name ) { 'attr_texes' }
        it 'it will prepend attr_ and append -es' do
          multiple_binding_method_name.should == expected_binding_method_name
        end
      end
    end
  
    #########################################
    #  required_single_binding_method_name  #
    #########################################
  
    context '#required_single_binding_method_name' do
      let( :expected_binding_method_name ) { 'attr_required_text' }
      let( :required_single_binding_method_name ) do
        _binding_name = binding_name
        instance.instance_eval { required_single_binding_method_name( _binding_name ) }
      end
      it 'will prepend attr_required_' do
        required_single_binding_method_name.should == expected_binding_method_name
      end
    end
  
    ###########################################
    #  required_multiple_binding_method_name  #
    ###########################################

    context '#required_multiple_binding_method_name' do
      let( :required_multiple_binding_method_name ) do
        _binding_name = binding_name
        instance.instance_eval { required_multiple_binding_method_name( _binding_name ) }
      end
      context 'when type ends with anything other than s or x' do
        let( :expected_binding_method_name ) { 'attr_required_texts' }
        it 'will prepend attr_ and append -s' do
          required_multiple_binding_method_name.should == expected_binding_method_name
        end
      end
      context 'when type ends with s' do
        let( :binding_name ) { 'texts' }
        let( :expected_binding_method_name ) { 'attr_required_textses' }
        it 'it will prepend attr_ and append -es' do
          required_multiple_binding_method_name.should == expected_binding_method_name
        end
      end
      context 'when type ends with x' do
        let( :binding_name ) { 'tex' }
        let( :expected_binding_method_name ) { 'attr_required_texes' }
        it 'it will prepend attr_ and append -es' do
          required_multiple_binding_method_name.should == expected_binding_method_name
        end
      end
    end
  
  end
  
  context '================  Defining Binding Methods  ================' do

    let( :binding_name ) { :some_type }
    
    ################################
    #  define_single_binding_type  #
    ################################
  
    shared_examples_for :define_single_binding_type do
      let( :method_name ) do
        _binding_name = binding_name
        parent_type_container.instance_eval { single_binding_method_name( _binding_name ) }.to_sym
      end
      it 'will define a method to create single-value bindings of type' do
        parent_type_container.instance_methods.include?( method_name ).should be true
      end
      it 'will cause children to inherit the binding' do
        child_type_container.instance_methods.include?( method_name ).should be true
      end
    end
  
    context '#define_single_binding_type' do
      let( :define_single_binding_type ) do
        _binding_name = binding_name
        parent_type_container.instance_eval { define_single_binding_type( _binding_name ) }
      end
      it_behaves_like :define_single_binding_type
      before :each do
        define_single_binding_type
      end
    end

    ##################################
    #  define_multiple_binding_type  #
    ##################################

    shared_examples_for :define_multiple_binding_type do
      let( :method_name ) do
        _binding_name = binding_name
        parent_type_container.instance_eval { multiple_binding_method_name( _binding_name ) }.to_sym
      end
      it 'will define a method to create single-value bindings of type' do
        parent_type_container.instance_methods.include?( method_name ).should be true
      end
      it 'will cause children to inherit the binding' do
        child_type_container.instance_methods.include?( method_name ).should be true
      end
    end
    
    context '#define_multiple_binding_type' do
      let( :define_multiple_binding_type ) do
        _binding_name = binding_name
        parent_type_container.instance_eval { define_multiple_binding_type( _binding_name ) }
      end
      it_behaves_like :define_multiple_binding_type
      before :each do
        define_multiple_binding_type
      end
    end

    #########################################
    #  define_required_single_binding_type  #
    #########################################

    shared_examples_for :define_required_single_binding_type do
      let( :method_name ) do
        _binding_name = binding_name
        parent_type_container.instance_eval { required_single_binding_method_name( _binding_name ) }.to_sym
      end
      it 'will define a method to create single-value bindings of type' do
        parent_type_container.instance_methods.include?( method_name ).should be true
      end
      it 'will cause children to inherit the binding' do
        child_type_container.instance_methods.include?( method_name ).should be true
      end
    end

    context '#define_required_single_binding_type' do
      let( :define_required_single_binding_type ) do
        _binding_name = binding_name
        parent_type_container.instance_eval { define_required_single_binding_type( _binding_name ) }
      end
      it_behaves_like :define_required_single_binding_type
      before :each do
        define_required_single_binding_type
      end
    end

    ###########################################
    #  define_required_multiple_binding_type  #
    ###########################################

    shared_examples_for :define_required_multiple_binding_type do
      let( :method_name ) do
        _binding_name = binding_name
        parent_type_container.instance_eval { required_multiple_binding_method_name( _binding_name ) }.to_sym
      end
      it 'will define a method to create single-value bindings of type' do
        parent_type_container.instance_methods.include?( method_name ).should be true
      end
      it 'will cause children to inherit the binding' do
        child_type_container.instance_methods.include?( method_name ).should be true
      end
    end

    context '#define_required_multiple_binding_type' do
      let( :define_required_multiple_binding_type ) do
        _binding_name = binding_name
        parent_type_container.instance_eval { define_required_multiple_binding_type( _binding_name ) }
      end
      it_behaves_like :define_required_multiple_binding_type
      before :each do
        define_required_multiple_binding_type
      end
    end

  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################
  
  #########################
  #  type_container_name  #
  #########################
  
  context '#type_container_name' do
    context 'when parent' do
      it 'has a unique name' do
        parent_type_container.type_container_name.should == parent_type_container_name
      end
    end
    context 'when child' do
      it 'has a unique name' do
        child_type_container.type_container_name.should == child_type_container_name
      end
    end
    context 'when child without subclassing' do
      it 'has a unique name' do
        child_without_subclassing_type_container.type_container_name.should == child_without_subclassing_type_container_name
      end
    end
  end

  ########################
  #  new_class_bindings  #
  ########################

  context '#new_class_bindings' do
    it 'creates new class bindings for a container, a list of names, and an optional block' do
      binding_type = parent_type_container.define_binding_type( :some_type )
      bound_container = ::Module.new do
        def self.__root__
          return self
        end
        def self.__root_string__
          return @__root_string__ ||= '<root:' << to_s << '>'
        end
      end
      new_bindings = parent_type_container.new_class_bindings( binding_type, bound_container, :some_name, :some_other_name, :another_name )
      new_bindings.each do |this_binding|
        this_binding.is_a?( ::Perspective::Bindings::BindingBase::ClassBinding ).should be true
        this_binding.is_a?( parent_type_container::SomeType ).should be true
        this_binding.__bound_container__.should be bound_container
      end
    end
  end

  #########################
  #  define_binding_type  #
  #########################

  context '#define_binding_type' do
    let( :instance ) { parent_type_container }
    let( :binding_name ) { 'text' }
    let( :define_binding_type ) do
      parent_type_container.define_binding_type( binding_name )
    end
    before :each do
      define_binding_type
    end
    it_behaves_like :define_single_binding_type
    it_behaves_like :define_multiple_binding_type
    it_behaves_like :define_required_single_binding_type
    it_behaves_like :define_required_multiple_binding_type
  end

  ########################
  #  alias_binding_type  #
  ########################

  context '#alias_binding_type' do
    let( :instance ) { parent_type_container }
    let( :binding_name ) { 'text' }
    let( :alias_name ) { :binding_alias }
    let( :binding_name ) { alias_name }
    let( :binding_to_alias ) { :some_type }
    let( :alias_binding_type ) do
      parent_type_container.define_binding_type( binding_to_alias )
      parent_type_container.alias_binding_type( alias_name, binding_to_alias )
    end
    before :each do
      alias_binding_type
    end
    it_behaves_like :define_single_binding_type
    it_behaves_like :define_multiple_binding_type
    it_behaves_like :define_required_single_binding_type
    it_behaves_like :define_required_multiple_binding_type
  end

end
