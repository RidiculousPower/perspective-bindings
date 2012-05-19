
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Types do

  it 'defines types based on binding definitions' do
    # attr_binding
    # attr_required_binding
    # attr_bindings
    # attr_required_bindings
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_binding ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_binding ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_bindings ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_bindings ).should == true
    # attr_class
    # attr_required_class
    # attr_classes
    # attr_required_classes
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_class ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_class ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_classes ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_classes ).should == true
    # attr_complex
    # attr_required_complex
    # attr_complexes
    # attr_required_complexes
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_complex ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_complex ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_complexes ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_complexes ).should == true
    # attr_file
    # attr_required_file
    # attr_files
    # attr_required_files
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_file ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_file ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_files ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_files ).should == true
    # attr_float
    # attr_required_float
    # attr_floats
    # attr_required_floats
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_float ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_float ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_floats ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_floats ).should == true
    # attr_integer
    # attr_required_integer
    # attr_integers
    # attr_required_integers
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_integer ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_integer ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_integers ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_integers ).should == true
    # attr_module
    # attr_required_module
    # attr_modules
    # attr_required_modules
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_module ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_module ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_modules ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_modules ).should == true
    # attr_number
    # attr_required_number
    # attr_numbers
    # attr_required_numbers
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_number ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_number ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_numbers ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_numbers ).should == true
    # attr_rational
    # attr_required_rational
    # attr_rationals
    # attr_required_rationals
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_rational ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_rational ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_rationals ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_rationals ).should == true
    # attr_regexp
    # attr_required_regexp
    # attr_regexps
    # attr_required_regexps
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_regexp ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_regexp ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_regexps ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_regexps ).should == true
    # attr_text
    # attr_required_text
    # attr_texts
    # attr_required_texts
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_text ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_text ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_texts ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_texts ).should == true
    # attr_true_false
    # attr_required_true_false
    # attr_true_falses
    # attr_required_true_falses
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_true_false ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_true_false ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_true_falses ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_true_falses ).should == true
    # attr_uri
    # attr_required_uri
    # attr_uris
    # attr_required_uris
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_uri ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_uri ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_uris ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_uris ).should == true
    # attr_url
    # attr_required_url
    # attr_urls
    # attr_required_urls
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_url ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_url ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_urls ).should == true
    ::Magnets::Binding::Container::ClassInstance.method_defined?( :attr_required_urls ).should == true
  end

end
