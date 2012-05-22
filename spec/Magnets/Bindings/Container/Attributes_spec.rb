
require_relative '../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Container::Attributes do

  before :all do
    
    class ::Magnets::Bindings::Container::Attributes::Mock
      include ::Magnets::Bindings::Container
      class Container
        include ::Magnets::Bindings::Container
      end
      extend ::Magnets::Bindings::Container::Attributes
    end
    
    ::Magnets::Bindings::Types.define_binding_type( 'alot_like_text' )
    ::Magnets::Bindings::Types.define_binding_type( 'also_alot_like_text' )
    
  end

  ##################################################################################################
  #   private ######################################################################################
  ##################################################################################################

	#######################################  Define Types  ###########################################

  ################################
  #  define_single_binding_type  #
  ################################

  it 'can define a single binding declaration method for a given type' do
    ::Magnets::Bindings::Container::Attributes::Mock.module_eval do
      define_single_binding_type( 'alot_like_text' )
      ::Magnets::Bindings::Container::Attributes::Mock::ClassInstance.method_defined?( :attr_alot_like_text ).should == true
    end
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  it 'can define a multiple binding declaration method for a given type' do
    ::Magnets::Bindings::Container::Attributes::Mock.module_eval do
      define_multiple_binding_type( 'alot_like_text' )
      ::Magnets::Bindings::Container::Attributes::Mock::ClassInstance.method_defined?( :attr_alot_like_texts ).should == true
    end
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  it 'can define a required single binding declaration method for a given type' do
    ::Magnets::Bindings::Container::Attributes::Mock.module_eval do
      define_required_single_binding_type( 'alot_like_text' )
      ::Magnets::Bindings::Container::Attributes::Mock::ClassInstance.method_defined?( :attr_required_alot_like_text ).should == true
    end
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  it 'can define a required multiple binding declaration method for a given type' do
    ::Magnets::Bindings::Container::Attributes::Mock.module_eval do
      define_required_multiple_binding_type( 'alot_like_text' )
      ::Magnets::Bindings::Container::Attributes::Mock::ClassInstance.method_defined?( :attr_required_alot_like_texts ).should == true
    end
  end

  ##################################################################################################
  #   public #######################################################################################
  ##################################################################################################

  ############################
  #  define_binding_methods  #
  ############################

  it 'can define all necessary supports for a binding type' do
    ::Magnets::Bindings::Container::Attributes::Mock.module_eval do
      
      define_binding_methods( 'also_alot_like_text' )

      ::Magnets::Bindings::Container::Attributes::Mock::ClassInstance.method_defined?( :attr_also_alot_like_text ).should == true
      ::Magnets::Bindings::Container::Attributes::Mock::ClassInstance.method_defined?( :attr_also_alot_like_texts ).should == true
      ::Magnets::Bindings::Container::Attributes::Mock::ClassInstance.method_defined?( :attr_required_also_alot_like_text ).should == true
      ::Magnets::Bindings::Container::Attributes::Mock::ClassInstance.method_defined?( :attr_required_also_alot_like_texts ).should == true

      new_bindings = attr_also_alot_like_text :some_binding, ::Magnets::Bindings::Container::Attributes::Mock::Container
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( ::Magnets::Bindings::Types::AlsoAlotLikeText ).should == true
      new_binding.required?.should == false

      new_bindings = attr_also_alot_like_texts :some_bindings, ::Magnets::Bindings::Container::Attributes::Mock::Container
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( ::Magnets::Bindings::Types::AlsoAlotLikeText::Multiple ).should == true
      new_binding.required?.should == false

      new_bindings = attr_required_also_alot_like_text :some_required_binding, ::Magnets::Bindings::Container::Attributes::Mock::Container
      new_binding = new_bindings[ 0 ]

      new_binding.is_a?( ::Magnets::Bindings::Types::AlsoAlotLikeText ).should == true
      new_binding.required?.should == true

      new_bindings = attr_required_also_alot_like_texts :some_required_bindings, ::Magnets::Bindings::Container::Attributes::Mock::Container
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( ::Magnets::Bindings::Types::AlsoAlotLikeText::Multiple ).should == true
      new_binding.required?.should == true

    end
  end

end
