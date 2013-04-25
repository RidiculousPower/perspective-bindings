# -*- encoding : utf-8 -*-

require_relative '../../binding_base/instance_binding.rb'

shared_examples_for :container_instance_binding do

  it_behaves_like :base_instance_binding
  
  #######################################
  #  initialize«container_from_class»  #
  #######################################
  
  context '#initialize«container_from_class»' do
    it 'will be extended with container instance binding methods' do
      topclass_class_binding_A.«container_class»::Controller::InstanceBindingMethods.should === topclass_instance_binding_A
    end
    it 'will create and store instance of container' do
      topclass_class_binding_A.«container_class».should === topclass_instance_binding_A.«container»
    end
  end
  
  #################
  #  «container»  #
  #################
  
  context '#«container»' do
    it 'will return the initialized container instance' do
      topclass_instance_binding_A.«container».should be_a topclass_class_binding_A.«container_class»
      topclass_instance_binding_A_B.«container».should be_a topclass_class_binding_A_B.«container_class»
      topclass_instance_binding_A_B_C.«container».should be_a topclass_class_binding_A_B_C.«container_class»
      subclass_instance_binding_A.«container».should be_a subclass_class_binding_A.«container_class»
      subclass_instance_binding_A_B.«container».should be_a subclass_class_binding_A_B.«container_class»
      subclass_instance_binding_A_B_C.«container».should be_a subclass_class_binding_A_B_C.«container_class»
    end
  end
  
  ##################
  #  «container»=  #
  ##################
  
  context '#«container»=' do
    after :each do
      ::CascadingConfiguration.unregister_parent( subclass_instance_binding_A_B_C, topclass_nested_container_instance_A )
    end
    it 'will store container, initializing self with container as parent (reverse the norm)' do
      subclass_instance_binding_A_B_C.«container» = topclass_nested_container_instance_A
      subclass_instance_binding_A_B_C.«container».should be topclass_nested_container_instance_A
      subclass_instance_binding_A_B_C.•«bindings».is_parent?( topclass_nested_container_instance_A ).should be true
    end
  end
  
  ###############
  #  container  #
  ###############
  
  context '#container' do
    it 'is an alias for #«container»' do
      topclass_instance_binding_A.class.instance_method( :container ).should == topclass_instance_binding_A.class.instance_method( :«container» )
    end
  end
  
  ################
  #  container=  #
  ################
  
  context '#container=' do
    it 'is an alias for #«container»=' do
      topclass_instance_binding_A.class.instance_method( :container= ).should == topclass_instance_binding_A.class.instance_method( :«container»= )
    end
  end
  
  ###################################
  #  «create_additional_container»  #
  ###################################
  
  context '#«create_additional_container»' do
    before :each do
      instance_of_multiple_container_class.•multiple_binding.«create_additional_container»
    end
    context 'only one container exists' do
      it 'will create another container, ensuring containers array exists internally' do
        instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers» ).size.should be 2
        instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers»)[ 0 ].should be_a nested_class_A_B_C
        instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers»)[ 1 ].should be_a nested_class_A_B_C
      end
    end
    context 'more than one container already exists' do
      before :each do
        instance_of_multiple_container_class.•multiple_binding.«create_additional_container»
      end
      it 'will create another container' do
        instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers» ).size.should be 3
        instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers»)[ 0 ].should be_a nested_class_A_B_C
        instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers»)[ 1 ].should be_a nested_class_A_B_C
        instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers»)[ 2 ].should be_a nested_class_A_B_C
      end
    end
  end
  
  ##############################
  #  «ensure_container_count»  #
  ##############################
  
  context '#«ensure_container_count»' do
    context 'does not permit multiple' do
      it 'will do nothing if count == 1' do
        instance_of_class.•a.«ensure_container_count»( 1 )
        instance_of_class.a.instance_variable_get( :@«containers» ).should be nil
      end
      it 'will raise ArgumentError if count > 1' do
        ::Proc.new { instance_of_class.•a.«ensure_container_count»( 2 ) }.should raise_error( ::ArgumentError )
      end
    end
    context 'no container class' do
      it 'will raise ArgumentError' do
        ::Proc.new { instance_of_class.a.b.•c.•content.«ensure_container_count»( 1 ) }.should raise_error( ::ArgumentError )
      end
    end
    context 'ensure 1 and one container currently exists' do
      it 'will do nothing' do
        instance_of_multiple_container_class.•multiple_binding.«ensure_container_count»( 1 )
        instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers» ).should be nil
      end
    end
    context 'ensure more than 1 and one container currently exists' do
      it 'will create necessary containers' do
        instance_of_multiple_container_class.•multiple_binding.«ensure_container_count»( 10 )
        instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers» ).size.should be 10
      end
    end
  end
  
  #######################
  #  «container_count»  #
  #######################
  
  context '#«container_count»' do
    context 'when permits_multiple? is false' do
      context 'when 0' do
        it 'will report 0' do
          instance_of_class.a.b.•c.•content.«container_count».should be 0
        end
      end
      context 'when 1' do
        it 'will report 1' do
          instance_of_class.a.b.•c.«container_count».should be 1
        end
      end
    end
    context 'when permits_multiple? is true' do
      context 'when 0' do
        it 'will report 0' do
          instance_of_multiple_container_class.•multiple_binding.•content.permits_multiple = true
          instance_of_multiple_container_class.•multiple_binding.•content.«container_count».should be 0
        end
      end
      context 'when 1' do
        it 'will report 1' do
          instance_of_multiple_container_class.•multiple_binding.«container_count».should be 1
        end
      end
      context 'when > 1' do
        it 'will report #' do
          instance_of_multiple_container_class.•multiple_binding.«ensure_container_count»( 2 )
          instance_of_multiple_container_class.•multiple_binding.«container_count».should be 2
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
        it 'will return «container» or autobind value' do
          instance_of_class.a[ 0 ].should be instance_of_class.•a.«container»
        end
      end
      context 'when multiple are permitted' do
        before :each do
          instance_of_multiple_container_class.•multiple_binding.«container»( 0 ).«autobind_value_to_binding».«value» = :autobind_binding_value
        end
        it 'will return «container» # or autobind value' do
          instance_of_multiple_container_class.•multiple_binding[ 0 ].should be :autobind_binding_value
        end
      end
    end
    context 'when index is negative' do
      context 'when multiple are not permitted' do
        it 'will return «container» or autobind value' do
          instance_of_class.a[ -1 ].should be instance_of_class.•a.«container»
        end
      end
      context 'when multiple are permitted' do
        context 'when only 1 exists' do
          it 'will return «container» or autobind value' do
            instance_of_multiple_container_class.•multiple_binding[ -1 ].should be instance_of_multiple_container_class.•multiple_binding.«value»
          end
        end
        context 'when more than 1 exists' do
          before :each do
            instance_of_multiple_container_class.•multiple_binding.«ensure_container_count»( 10 )
          end
          it 'will return container corresponding to index' do
            instance_of_multiple_container_class.•multiple_binding[ -1 ].should be instance_of_multiple_container_class.•multiple_binding[ 9 ]
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
        it 'will return container or autobind value for index # (creating if necessary and possible)' do
          instance_of_multiple_container_class.•multiple_binding[ 9 ].should be nil
        end
      end
    end
  end

  ###################
  #  set_container  #
  ###################

  context '#set_container' do
    context 'when multiple are not permitted' do
      it 'will be equivalent to «container»= for index 0' do
        new_container_instance = nested_class_A_B.new
        instance_of_class.•a.«set_container»( 0, new_container_instance )
        instance_of_class.•a.«container».should be new_container_instance
      end
      it 'will be equivalent to «container»= for index -1' do
        new_container_instance = nested_class_A_B.new
        instance_of_class.•a.«set_container»( -1, new_container_instance )
        instance_of_class.•a.«container».should be new_container_instance
      end
      it 'will raise ArgumentError for index > 0' do
        new_container_instance = nested_class_A_B.new
        ::Proc.new { instance_of_class.•a.«set_container»( 1, new_container_instance ) }.should raise_error( ::ArgumentError )
      end
      it 'will raise ArgumentError for index < -1' do
        new_container_instance = nested_class_A_B.new
        ::Proc.new { instance_of_class.•a.«set_container»( -2, new_container_instance ) }.should raise_error( ::IndexError )
      end
    end
    context 'when multiple are permitted' do
      it 'will be equivalent to «container»= for index 0' do
        new_container_instance = nested_class_A_B.new
        instance_of_multiple_container_class.•multiple_binding.«set_container»( 0, new_container_instance )
        instance_of_multiple_container_class.•multiple_binding.«container».should be new_container_instance
      end
      it 'will set the corresponding container for index == 1' do
        new_container_instance = nested_class_A_B.new
        instance_of_multiple_container_class.•multiple_binding.«set_container»( 1, new_container_instance )
        instance_of_multiple_container_class.•multiple_binding[ 1 ].should be new_container_instance
      end
      it 'will set the corresponding container for index > 1' do
        new_container_instance = nested_class_A_B.new
        instance_of_multiple_container_class.•multiple_binding.«set_container»( 2, new_container_instance )
        instance_of_multiple_container_class.•multiple_binding.«container»( 1 ).should be_a multiple_container_class.•multiple_binding.«container_class»
        instance_of_multiple_container_class.•multiple_binding.«container»( 2 ).should be new_container_instance
      end
      it 'will set the corresponding container for index < 0' do
        new_container_instance = nested_class_A_B.new
        instance_of_multiple_container_class.•multiple_binding.«set_container»( -1, new_container_instance )
        instance_of_multiple_container_class.•multiple_binding[ 0 ].should be new_container_instance
      end
      it 'will raise ArgumentError for index < -# of containers' do
        new_container_instance = nested_class_A_B.new
        ::Proc.new { instance_of_multiple_container_class.•multiple_binding.«set_container»( -2, new_container_instance ) }.should raise_error( ::IndexError )
      end
    end
  end

  #########
  #  []=  #
  #########

  context '#[]=' do
    context 'when multiple are not permitted' do
      it 'will be equivalent to «container»= for index 0' do
        instance_of_class.a.b.•c[ 0 ] = :value
        instance_of_class.a.b.c.should be :value
      end
      it 'will be equivalent to «container»= for index -1' do
        instance_of_class.a.b.•c[ -1 ] = :value
        instance_of_class.a.b.c.should be :value
      end
      it 'will raise ArgumentError for index > 0' do
        ::Proc.new { instance_of_class.a.b.•c[ 1 ] = :value }.should raise_error( ::ArgumentError )
      end
      it 'will raise ArgumentError for index < -1' do
        ::Proc.new { instance_of_class.a.b.•c[ -2 ] = :value }.should raise_error( ::IndexError )
      end
    end
    context 'when multiple are permitted' do
      it 'will be equivalent to «container»= for index 0' do
        instance_of_multiple_container_class.•multiple_binding[ 0 ] = :value
        instance_of_multiple_container_class.multiple_binding.«container»( 0 ).«autobind_value_to_binding».«value».should be :value
      end
      it 'will set the corresponding container for index == 1' do
        instance_of_multiple_container_class.•multiple_binding[ 1 ] = :value
        instance_of_multiple_container_class.•multiple_binding[ 1 ].should be :value
      end
      it 'will set the corresponding container for index > 1' do
        instance_of_multiple_container_class.•multiple_binding[ 2 ] = :value
        instance_of_multiple_container_class.•multiple_binding[ 1 ].should be nil
        instance_of_multiple_container_class.•multiple_binding[ 2 ].should be :value
      end
      it 'will set the corresponding container for index < 0' do
        instance_of_multiple_container_class.•multiple_binding[ -1 ] = :value
        instance_of_multiple_container_class.•multiple_binding[ 0 ].should be :value
      end
      it 'will raise ArgumentError for index < -# of containers' do
        ::Proc.new { instance_of_multiple_container_class.•multiple_binding[ -2 ] = :value }.should raise_error( ::IndexError )
      end
    end
  end

  ##########
  #  each  #
  ##########

  context '#each' do
    context 'when multiple are not permitted' do
      it 'will iterate' do
        instance_of_class.a.collect { |container| container }.should == [ instance_of_class.•a.«container» ]
      end
    end
    context 'when multiple are permitted' do
      it 'will iterate' do
        instance_of_multiple_container_class.•multiple_binding.«ensure_container_count»( 4 )
        instance_of_multiple_container_class.•multiple_binding.collect { |container| container }.should == instance_of_multiple_container_class.•multiple_binding.instance_variable_get( :@«containers» )
      end
    end
  end
    
  ###########
  #  value  #
  ###########

  context '#value' do
    it 'is an alias for #«value»' do
      topclass_instance_binding_A.class.instance_method( :value ).should == topclass_instance_binding_A.class.instance_method( :«value» )
    end
  end
  
  ############
  #  value=  #
  ############

  context '#value=' do
    it 'is an alias for #«value»=' do
      topclass_instance_binding_A.class.instance_method( :value= ).should == topclass_instance_binding_A.class.instance_method( :«value»= )
    end
  end
  
  ####################
  #  «nested_route»  #
  ####################
  
  context '#«nested_route»' do
    context 'binding is nested in queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_instance_binding_A_B.«nested_route»( topclass_instance_binding_A ).should == nil
      end
    end
    context 'binding is nested in binding under queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_instance_binding_A_B_C.«nested_route»( topclass_instance_binding_A ).should == [ topclass_class_binding_A_B_name ]
      end
    end
  end

end
