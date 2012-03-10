
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias::Mock
      extend Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias
      def self.aliased_method
        @called_aliased_method = true
      end
      def self.called_aliased_method
        did_call_method = @called_aliased_method
        @called_aliased_method = false
        return did_call_method
      end
      def aliased_method
        @called_aliased_method = true
      end
      def aliased_method=( something )
        @called_aliased_method = true
      end
      def called_aliased_method
        did_call_method = @called_aliased_method
        @called_aliased_method = false
        return did_call_method
      end
    end
  end

  ##########################################
  #  declare_aliased_class_binding_getter  #
  ##########################################
  
  it 'can declare an aliased binding getter class method' do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias::Mock
      declare_aliased_class_binding_getter( :new_alias, :aliased_method )
      respond_to?( :new_alias ).should == true
      new_alias
      called_aliased_method.should == true
    end
  end
  
	####################################
  #  declare_aliased_binding_setter  #
  ####################################

  it 'can declare an aliased binding getter instance method' do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias::Mock
      declare_aliased_binding_setter( :new_alias, :aliased_method )
      instance_methods.include?( :new_alias= ).should == true
    end
    ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias::Mock.new.instance_eval do
      self.new_alias = Object.new
      called_aliased_method.should == true
    end
  end

	####################################
  #  declare_aliased_binding_getter  #
  ####################################

  it 'can declare an aliased binding getter instance method' do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias::Mock
      declare_aliased_binding_getter( :new_alias, :aliased_method )
      instance_methods.include?( :new_alias ).should == true
    end
    ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias::Mock.new.instance_eval do
      self.new_alias
      called_aliased_method.should == true
    end
  end

end
