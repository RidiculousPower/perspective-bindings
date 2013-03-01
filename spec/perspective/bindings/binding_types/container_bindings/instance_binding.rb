
require_relative '../../binding_base/instance_binding.rb'

shared_examples_for :container_instance_binding do

  it_behaves_like :base_instance_binding
  
  #########################################
  #  __initialize_container_from_class__  #
  #########################################
  
  context '#__initialize_container_from_class__' do
    it 'will be extended with container instance binding methods' do
      topclass_class_binding_A.__container_class__::Controller::InstanceBindingMethods.should === topclass_instance_binding_A
    end
    it 'will create and store instance of container' do
      topclass_class_binding_A.__container_class__.should === topclass_instance_binding_A.__container__
    end
  end
  
  ###################
  #  __container__  #
  ###################

  context '#__container__' do
    it 'will return the initialized container instance' do
      topclass_instance_binding_A.__container__.should be_a topclass_class_binding_A.__container_class__
      topclass_instance_binding_A_B.__container__.should be_a topclass_class_binding_A_B.__container_class__
      topclass_instance_binding_A_B_C.__container__.should be_a topclass_class_binding_A_B_C.__container_class__
      subclass_instance_binding_A.__container__.should be_a subclass_class_binding_A.__container_class__
      subclass_instance_binding_A_B.__container__.should be_a subclass_class_binding_A_B.__container_class__
      subclass_instance_binding_A_B_C.__container__.should be_a subclass_class_binding_A_B_C.__container_class__
    end
  end
  
  ####################
  #  __container__=  #
  ####################

  context '#__container__=' do
    it 'will store container, initializing self with container as parent (reverse the norm)' do
      subclass_instance_binding_A_B_C.__container__ = topclass_nested_container_instance_A
      subclass_instance_binding_A_B_C.__container__.should be topclass_nested_container_instance_A
      CascadingConfiguration.configuration( subclass_instance_binding_A_B_C, :__bindings__ ).is_parent?( topclass_nested_container_instance_A ).should be true
    end
  end
  
  ###############
  #  container  #
  ###############

  context '#container' do
    it 'is an alias for #__container__' do
      topclass_instance_binding_A.class.instance_method( :container ).should == topclass_instance_binding_A.class.instance_method( :__container__ )
    end
  end
  
  ################
  #  container=  #
  ################

  context '#container=' do
    it 'is an alias for #__container__=' do
      topclass_instance_binding_A.class.instance_method( :container= ).should == topclass_instance_binding_A.class.instance_method( :__container__= )
    end
  end
  
  #####################################
  #  __create_additional_container__  #
  #####################################

  context '#__create_additional_container__' do
    before :each do
      instance_of_multiple_container_class.multiple_binding.__create_additional_container__
    end
    context 'only one container exists' do
      it 'will create another container, ensuring containers array exists internally' do
        instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__ ).size.should be 2
        instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__)[ 0 ].should be_a nested_class_A_B_C
        instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__)[ 1 ].should be_a nested_class_A_B_C
      end
    end
    context 'more than one container already exists' do
      before :each do
        instance_of_multiple_container_class.multiple_binding.__create_additional_container__
      end
      it 'will create another container' do
        instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__ ).size.should be 3
        instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__)[ 0 ].should be_a nested_class_A_B_C
        instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__)[ 1 ].should be_a nested_class_A_B_C
        instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__)[ 2 ].should be_a nested_class_A_B_C
      end
    end
  end

  ################################
  #  __ensure_container_count__  #
  ################################

  context '#__ensure_container_count__' do
    context 'does not permit multiple' do
      it 'will do nothing if count == 1' do
        instance_of_class.a.__ensure_container_count__( 1 )
        instance_of_class.a.instance_variable_get( :@__containers__ ).should be nil
      end
      it 'will raise ArgumentError if count > 1' do
        ::Proc.new { instance_of_class.a.__ensure_container_count__( 2 ) }.should raise_error( ::ArgumentError )
      end
    end
    context 'no container class' do
      it 'will raise ArgumentError' do
        ::Proc.new { instance_of_class.a.b.c.content.__ensure_container_count__( 1 ) }.should raise_error( ::ArgumentError )
      end
    end
    context 'ensure 1 and one container currently exists' do
      it 'will do nothing' do
        instance_of_multiple_container_class.multiple_binding.__ensure_container_count__( 1 )
        instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__ ).should be nil
      end
    end
    context 'ensure more than 1 and one container currently exists' do
      it 'will create necessary containers' do
        instance_of_multiple_container_class.multiple_binding.__ensure_container_count__( 10 )
        instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__ ).size.should be 10
      end
    end
  end
  
  #########################
  #  __container_count__  #
  #########################

  context '#__container_count__' do
    context 'when permits_multiple? is false' do
      context 'when 0' do
        it 'will report 0' do
          instance_of_class.a.b.c.content.__container_count__.should be 0
        end
      end
      context 'when 1' do
        it 'will report 1' do
          instance_of_class.a.b.c.__container_count__.should be 1
        end
      end
    end
    context 'when permits_multiple? is true' do
      context 'when 0' do
        it 'will report 0' do
          instance_of_multiple_container_class.multiple_binding.content.permits_multiple = true
          instance_of_multiple_container_class.multiple_binding.content.__container_count__.should be 0
        end
      end
      context 'when 1' do
        it 'will report 1' do
          instance_of_multiple_container_class.multiple_binding.__container_count__.should be 1
        end
      end
      context 'when > 1' do
        it 'will report #' do
          instance_of_multiple_container_class.multiple_binding.__ensure_container_count__( 2 )
          instance_of_multiple_container_class.multiple_binding.__container_count__.should be 2
        end
      end
    end
  end

  ########
  #  []  #
  ########

  context '#[]' do
    context 'when symbol' do
      it 'will return binding for binding name' do
        instance_of_class.a[ :b ].should be instance_of_class.a.b
      end
    end
    context 'when string' do
      it 'will return binding for binding name' do
        instance_of_class.a[ 'b' ].should be instance_of_class.a.b
      end
    end
    context 'when index == 0' do
      context 'when multiple are not permitted' do
        it 'will return __container__' do
          instance_of_class.a[ 0 ].should be instance_of_class.a.__container__
        end
      end
      context 'when multiple are permitted' do
        it 'will return __container__' do
          instance_of_multiple_container_class.multiple_binding[ 0 ].should be instance_of_multiple_container_class.multiple_binding.__container__
        end
      end
    end
    context 'when index is negative' do
      context 'when multiple are not permitted' do
        it 'will return __container__' do
          instance_of_class.a[ -1 ].should be instance_of_class.a.__container__
        end
      end
      context 'when multiple are permitted' do
        context 'when only 1 exists' do
          it 'will return __container__' do
            instance_of_multiple_container_class.multiple_binding[ -1 ].should be instance_of_multiple_container_class.multiple_binding.__container__
          end
        end
        context 'when more than 1 exists' do
          before :each do
            instance_of_multiple_container_class.multiple_binding.__ensure_container_count__( 10 )
          end
          it 'will return container corresponding to index' do
            instance_of_multiple_container_class.multiple_binding[ -1 ].should be instance_of_multiple_container_class.multiple_binding[ 9 ]
          end
        end
      end
    end
    context 'when index > 0' do
      context 'when multiple are not permitted' do
        it 'will raise ArgumentError' do
          ::Proc.new { instance_of_class.a[ 2 ] }.should raise_error( ArgumentError )
        end
      end
      context 'when multiple are permitted' do
        it 'will return container for index # (creating if necessary and possible)' do
          instance_of_multiple_container_class.multiple_binding[ 9 ].should be_a nested_class_A_B_C
        end
      end
    end
  end

  #########
  #  []=  #
  #########

  context '#[]=' do
    context 'when multiple are not permitted' do
      it 'will be equivalent to __container__= for index 0' do
        new_container_instance = nested_class_A_B_C.new
        instance_of_class.a[ 0 ] = new_container_instance
        instance_of_class.a.__container__.should be new_container_instance
      end
      it 'will be equivalent to __container__= for index -1' do
        new_container_instance = nested_class_A_B_C.new
        instance_of_class.a[ -1 ] = new_container_instance
        instance_of_class.a.__container__.should be new_container_instance
      end
      it 'will raise ArgumentError for index > 0' do
        new_container_instance = nested_class_A_B_C.new
        ::Proc.new { instance_of_class.a[ 1 ] = new_container_instance }.should raise_error( ::ArgumentError )
      end
      it 'will raise ArgumentError for index < -1' do
        new_container_instance = nested_class_A_B_C.new
        ::Proc.new { instance_of_class.a[ -2 ] = new_container_instance }.should raise_error( ::IndexError )
      end
    end
    context 'when multiple are permitted' do
      it 'will be equivalent to __container__= for index 0' do
        new_container_instance = nested_class_A_B_C.new
        instance_of_multiple_container_class.multiple_binding[ 0 ] = new_container_instance
        instance_of_multiple_container_class.multiple_binding.__container__.should be new_container_instance
      end
      it 'will set the corresponding container for index == 1' do
        new_container_instance = nested_class_A_B_C.new
        instance_of_multiple_container_class.multiple_binding[ 1 ] = new_container_instance
        instance_of_multiple_container_class.multiple_binding[ 1 ].should be new_container_instance
      end
      it 'will set the corresponding container for index > 1' do
        new_container_instance = nested_class_A_B_C.new
        instance_of_multiple_container_class.multiple_binding[ 2 ] = new_container_instance
        instance_of_multiple_container_class.multiple_binding[ 1 ].should be_a instance_of_multiple_container_class.multiple_binding.__parent_binding__.__container_class__
        instance_of_multiple_container_class.multiple_binding[ 2 ].should be new_container_instance
      end
      it 'will set the corresponding container for index < 0' do
        new_container_instance = nested_class_A_B_C.new
        instance_of_multiple_container_class.multiple_binding[ -1 ] = new_container_instance
        instance_of_multiple_container_class.multiple_binding[ 0 ].should be new_container_instance
      end
      it 'will raise ArgumentError for index < -# of containers' do
        new_container_instance = nested_class_A_B_C.new
        ::Proc.new { instance_of_multiple_container_class.multiple_binding[ -2 ] = new_container_instance }.should raise_error( ::IndexError )
      end
    end
  end
    
  ##########
  #  each  #
  ##########

  context '#each' do
    context 'when multiple are not permitted' do
      it 'will iterate' do
        instance_of_class.a.collect { |container| container }.should == [ instance_of_class.a.__container__ ]
      end
    end
    context 'when multiple are permitted' do
      it 'will iterate' do
        instance_of_multiple_container_class.multiple_binding.__ensure_container_count__( 4 )
        instance_of_multiple_container_class.multiple_binding.collect { |container| container }.should == instance_of_multiple_container_class.multiple_binding.instance_variable_get( :@__containers__ )
      end
    end
  end
    
  ###########
  #  value  #
  ###########

  context '#value' do
    it 'is an alias for #__value__' do
      topclass_instance_binding_A.class.instance_method( :value ).should == topclass_instance_binding_A.class.instance_method( :__value__ )
    end
  end
  
  ############
  #  value=  #
  ############

  context '#value=' do
    it 'is an alias for #__value__=' do
      topclass_instance_binding_A.class.instance_method( :value= ).should == topclass_instance_binding_A.class.instance_method( :__value__= )
    end
  end
  
  ######################
  #  __nested_route__  #
  ######################
  
  context '#__nested_route__' do
    context 'binding is nested in queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_instance_binding_A_B.__nested_route__( topclass_instance_binding_A ).should == nil
      end
    end
    context 'binding is nested in binding under queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_instance_binding_A_B_C.__nested_route__( topclass_instance_binding_A ).should == [ topclass_class_binding_A_B_name ]
      end
    end
  end

end
