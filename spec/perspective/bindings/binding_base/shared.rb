
shared_examples_for :shared_binding do

  #########################
  #  __bound_container__  #
  #########################
  
  context '#__bound_container__' do
    it 'topclass binding has its bound container' do
      topclass_binding.__bound_container__.should == topclass_bound_container
    end
    it 'subclass binding has its bound container' do
      subclass_binding.__bound_container__.should == subclass_bound_container
    end
  end
  
  ##############
  #  __root__  #
  ##############
  
  context '#__root__' do
    it 'topclass binding has bound container as root' do
      topclass_binding.__root__.should == topclass_bound_container
    end
    it 'subclass binding has bound container as root' do
      subclass_binding.__root__.should == subclass_bound_container
    end
  end

  ##############
  #  __name__  #
  ##############
  
  context '#__name__' do
    it 'topclass binding has a name' do
      topclass_binding.__name__.should == binding_name
    end
    it 'subclass binding has the same name' do
      subclass_binding.__name__.should == topclass_binding.__name__
    end
  end
  
  ###############
  #  __route__  #
  ###############

  context '#__route__' do
    it 'topclass binding has no route since it is in the root container' do
      topclass_binding.__route__.should == nil
    end
    it 'subclass binding has no route since it is in the root container' do
      subclass_binding.__route__.should == nil
    end
  end

  #########################
  #  __route_with_name__  #
  #########################

  context '#__route_with_name__' do
    it 'topclass binding route with name is binding name' do
      topclass_binding.__route_with_name__.should == [ binding_name ]
    end
    it 'subclass binding route with name is binding name' do
      subclass_binding.__route_with_name__.should == [ binding_name ]
    end
  end

  ######################
  #  __route_string__  #
  ######################

  context '#__route_string__' do
    it 'topclass binding route string is its name' do
      topclass_binding.__route_string__.should == ::Perspective::Bindings.context_string( topclass_binding.__route_with_name__ )
    end
    it 'subclass binding route string is its name' do
      subclass_binding.__route_string__.should == ::Perspective::Bindings.context_string( subclass_binding.__route_with_name__ )
    end
  end

  ############################
  #  __route_print_string__  #
  ############################

  context '#__route_print_string__' do
    it 'topclass binding print string is root plus route string' do
      topclass_binding.__route_print_string__.should == ::Perspective::Bindings.context_print_string( topclass_bound_container, topclass_binding.__route_string__ )
    end
    it 'subclass binding print string is root plus route string' do
      subclass_binding.__route_print_string__.should == ::Perspective::Bindings.context_print_string( subclass_bound_container, subclass_binding.__route_string__ )
    end
  end

end
