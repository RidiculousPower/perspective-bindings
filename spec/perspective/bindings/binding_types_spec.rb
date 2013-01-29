
require_relative '../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::Attributes do

  ################################
  #  self.define_container_type  #
  #  self.create_container_type  #
  #  self.type_container        #
  ################################

  it 'can define a container type, automatically creating it, define further on an existing container, or return a container by name' do
    proc_ran = false
    define_proc = Proc.new do
      proc_ran = true
    end
    
    # without parent container or base class specification
    instance = ::Perspective::Bindings::BindingTypes.define_container_type( :container1, & define_proc )
    proc_ran.should == true
    proc_ran = false
    ::Perspective::Bindings::BindingTypeContainer.type_container( :container1 ).should == instance

    parent_instance = instance
      
    # with parent container no base class specification
    instance = ::Perspective::Bindings::BindingTypes.define_container_type( :container2, parent_instance, true, & define_proc )
    instance.ancestors.include?( parent_instance ).should == true
    proc_ran.should == true
    proc_ran = false
    ::Perspective::Bindings::BindingTypeContainer.type_container( :container2 ).should == instance
  end

  it 'defines types based on binding definitions' do
    # attr_binding
    # attr_required_binding
    # attr_bindings
    # attr_required_bindings
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_binding ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_binding ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_bindings ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_bindings ).should == true
    # attr_class
    # attr_required_class
    # attr_classes
    # attr_required_classes
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_class ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_class ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_classes ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_classes ).should == true
    # attr_complex
    # attr_required_complex
    # attr_complexes
    # attr_required_complexes
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_complex ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_complex ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_complexes ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_complexes ).should == true
    # attr_file
    # attr_required_file
    # attr_files
    # attr_required_files
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_file ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_file ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_files ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_files ).should == true
    # attr_float
    # attr_required_float
    # attr_floats
    # attr_required_floats
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_float ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_float ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_floats ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_floats ).should == true
    # attr_integer
    # attr_required_integer
    # attr_integers
    # attr_required_integers
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_integer ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_integer ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_integers ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_integers ).should == true
    # attr_module
    # attr_required_module
    # attr_modules
    # attr_required_modules
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_module ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_module ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_modules ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_modules ).should == true
    # attr_number
    # attr_required_number
    # attr_numbers
    # attr_required_numbers
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_number ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_number ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_numbers ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_numbers ).should == true
    # attr_rational
    # attr_required_rational
    # attr_rationals
    # attr_required_rationals
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_rational ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_rational ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_rationals ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_rationals ).should == true
    # attr_regexp
    # attr_required_regexp
    # attr_regexps
    # attr_required_regexps
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_regexp ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_regexp ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_regexps ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_regexps ).should == true
    # attr_text
    # attr_required_text
    # attr_texts
    # attr_required_texts
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_text ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_text ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_texts ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_texts ).should == true
    # attr_true_false
    # attr_required_true_false
    # attr_true_falses
    # attr_required_true_falses
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_true_false ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_true_false ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_true_falses ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_true_falses ).should == true
    # attr_uri
    # attr_required_uri
    # attr_uris
    # attr_required_uris
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_uri ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_uri ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_uris ).should == true
    ::Perspective::Bindings::BindingTypeContainer::Bindings.method_defined?( :attr_required_uris ).should == true
  end

end
