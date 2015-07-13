Puppet::Parser::Functions.newfunction(:get_dimensions, :type => :rvalue) do |args| 
dimension_list = args[0]
DIMENSIONS = ""
unless dimension_list.empty? 
DIMENSIONS << "?"
dimension_list.each {|key, value| DIMENSIONS << "sfxdim_#{key}=#{value}&"}
end
DIMENSIONS[0...-1]
end
