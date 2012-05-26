
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::AttributeDefinitionModule do

  before :all do
    
    module AttributeDefinitionModuleMockA
      extend ::Magnets::Bindings::AttributeDefinitionModule
    end

    module AttributeDefinitionModuleMockB
    end

    module AttributeDefinitionModuleExtensionMockA
    end
    
  end

  ##############
  #  included  #
  ##############
  
  it 'can track modules that include it' do
    module AttributeDefinitionModuleMockB
      include AttributeDefinitionModuleMockA
    end
    module AttributeDefinitionModuleMockA
      @modules_including_self.include?( AttributeDefinitionModuleMockB ).should == true
    end
  end

  #############
  #  include  #
  #############

  it 'can relay includes to modules that have included it' do
    module AttributeDefinitionModuleMockA
      include AttributeDefinitionModuleExtensionMockA
    end
    AttributeDefinitionModuleMockB.ancestors.include?( AttributeDefinitionModuleExtensionMockA ).should == true
  end

end
