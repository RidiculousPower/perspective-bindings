# -*- encoding : utf-8 -*-

class ::Class

  instance_methods.each do |this_method|
    alias_method '«' << this_method.to_s << '»', this_method
  end
  
end
