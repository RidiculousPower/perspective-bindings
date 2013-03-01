
shared_examples_for :shared_binding do

  #########################
  #  «bound_container  #
  #########################
  
  context '#«bound_container' do
    it 'topclass binding has its bound container' do
      topclass_binding.«bound_container.should == topclass_bound_container
    end
    it 'subclass binding has its bound container' do
      subclass_binding.«bound_container.should == subclass_bound_container
    end
  end
  
  ##############
  #  «root  #
  ##############
  
  context '#«root' do
    it 'topclass binding has bound container as root' do
      topclass_binding.«root.should == topclass_bound_container
    end
    it 'subclass binding has bound container as root' do
      subclass_binding.«root.should == subclass_bound_container
    end
  end

  ##############
  #  «name  #
  ##############
  
  context '#«name' do
    it 'topclass binding has a name' do
      topclass_binding.«name.should == binding_name
    end
    it 'subclass binding has the same name' do
      subclass_binding.«name.should == topclass_binding.«name
    end
  end
  
  ###############
  #  «route  #
  ###############

  context '#«route' do
    it 'topclass binding has no route since it is in the root container' do
      topclass_binding.«route.should == nil
    end
    it 'subclass binding has no route since it is in the root container' do
      subclass_binding.«route.should == nil
    end
  end

  #########################
  #  «route_with_name  #
  #########################

  context '#«route_with_name' do
    it 'topclass binding route with name is binding name' do
      topclass_binding.«route_with_name.should == [ binding_name ]
    end
    it 'subclass binding route with name is binding name' do
      subclass_binding.«route_with_name.should == [ binding_name ]
    end
  end

  ######################
  #  «route_string  #
  ######################

  context '#«route_string' do
    it 'topclass binding route string is its name' do
      topclass_binding.«route_string.should == ::Perspective::Bindings.context_string( topclass_binding.«route_with_name )
    end
    it 'subclass binding route string is its name' do
      subclass_binding.«route_string.should == ::Perspective::Bindings.context_string( subclass_binding.«route_with_name )
    end
  end

  ############################
  #  «route_print_string  #
  ############################

  context '#«route_print_string' do
    it 'topclass binding print string is root plus route string' do
      topclass_binding.«route_print_string.should == ::Perspective::Bindings.context_print_string( topclass_bound_container, topclass_binding.«route_string )
    end
    it 'subclass binding print string is root plus route string' do
      subclass_binding.«route_print_string.should == ::Perspective::Bindings.context_print_string( subclass_bound_container, subclass_binding.«route_string )
    end
  end

end
