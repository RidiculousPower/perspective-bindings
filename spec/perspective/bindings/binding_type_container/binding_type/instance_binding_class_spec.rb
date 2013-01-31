
require_relative '../../../../../lib/perspective/bindings.rb'

require_relative '../../../../support/named_class_and_module.rb'

describe ::Perspective::Bindings::BindingTypeContainer::BindingType::InstanceBindingClass do

  #########################
  #  respond_to_missing?  #
  #########################
  
  context '#respond_to_missing?' do
  end
  
  ####################
  #  method_missing  #
  ####################
	
  context '#method_missing' do
  	it 'forwards almost all methods to its value' do
  	  non_forwarded_methods = [ :method_missing, :object_id, :hash, :==,
                                :equal?, :class, 
                                :view, :view=, :container, :container=, :to_html_node ]
      non_forwarded_methods.each do |this_method_name|
        @instance_binding.__instance_eval__ do
          respond_to_missing?( this_method_name, true ).should == false
        end
      end
      @instance_binding.respond_to_missing?( :some_other_method, true ).should == true
    end
  end
  
end
